#!/usr/bin/env bash
# Publish ambition-lenses: creates the GitHub repo, pushes, tags a release with an
# uploadable skill zip, and (optionally) publishes to npm for the pi package gallery.
#
#   bash publish.sh            # GitHub repo + release
#   NPM=1 bash publish.sh      # ...and npm (pi gallery)
#   DRY_RUN=1 bash publish.sh  # fill in your details and build, but publish nothing
set -euo pipefail
cd "$(dirname "$0")"

REPO=ambition-lenses
VERSION=$(node -p "require('./package.json').version" 2>/dev/null || echo 1.0.0)

say() { printf '\n\033[1m%s\033[0m\n' "$*"; }

# 1. Tools and login --------------------------------------------------------
if [ -z "${DRY_RUN:-}" ]; then
  command -v git >/dev/null || { echo "git is required (macOS: xcode-select --install)"; exit 1; }
  command -v gh  >/dev/null || { echo "GitHub CLI is required: brew install gh"; exit 1; }
  gh auth status >/dev/null 2>&1 || gh auth login --web --git-protocol https
  OWNER=$(gh api user -q .login)
  AUTHOR=$(gh api user -q '.name // .login')
  USER_ID=$(gh api user -q .id)
else
  OWNER=${OWNER:-example-user}; AUTHOR=${AUTHOR:-Example User}; USER_ID=0
  TMP=$(mktemp -d); cp -R . "$TMP/$REPO"; cd "$TMP/$REPO"   # dry run works on a copy
fi
say "Publishing as $AUTHOR (github.com/$OWNER)"

# 2. Fill in placeholders ---------------------------------------------------
OWNER="$OWNER" AUTHOR="$AUTHOR" perl -pi -e 's/__AUTHOR__/$ENV{AUTHOR}/g; s/\bOWNER\b/$ENV{OWNER}/g' \
  README.md LICENSE package.json .claude-plugin/plugin.json .claude-plugin/marketplace.json

# 3. Build the claude.ai upload zip -----------------------------------------
rm -f ambition-lenses-skill.zip
(cd skills && zip -rq ../ambition-lenses-skill.zip ambition-lenses -x '*.DS_Store')

# 4. Validate (if Claude Code is installed) ---------------------------------
if command -v claude >/dev/null; then claude plugin validate . ; fi

if [ -n "${DRY_RUN:-}" ]; then say "Dry run done. Nothing was published."; exit 0; fi

# 5. Git commit -------------------------------------------------------------
say "Creating git repo"
[ -d .git ] || git init -q -b main
git config user.name  >/dev/null || git config user.name  "$AUTHOR"
git config user.email >/dev/null || git config user.email "${USER_ID}+${OWNER}@users.noreply.github.com"
git add -A
git commit -qm "ambition-lenses v$VERSION" || true

# 6. Create the public repo and push ----------------------------------------
if gh repo view "$OWNER/$REPO" >/dev/null 2>&1; then
  # Re-run after a partial failure: push to the repo this script already created.
  git remote get-url origin >/dev/null 2>&1 || { echo "github.com/$OWNER/$REPO already exists and isn't this folder's remote. Rename or delete it first."; exit 1; }
  say "Repo exists, pushing"
  git push -u origin main
else
  say "Creating github.com/$OWNER/$REPO"
  gh repo create "$OWNER/$REPO" --public --source=. --remote=origin --push \
  --description "Super-developer operating philosophy for AI agents: Speed, Altitude, Depth, Range. Works in Claude, Claude Code and pi."
fi
gh repo edit "$OWNER/$REPO" --add-topic agent-skills,claude-code,claude-skills,pi-package,ai-agents,llm

# 7. Tag a release with the uploadable zip ----------------------------------
say "Creating release v$VERSION"
gh release view "v$VERSION" >/dev/null 2>&1 || gh release create "v$VERSION" ambition-lenses-skill.zip --title "v$VERSION" \
  --notes "Install: see README. For the Claude app, upload ambition-lenses-skill.zip in your skills settings."

# 8. Optional: npm, which lists it in the pi package gallery ---------------
if [ -n "${NPM:-}" ]; then
  say "Publishing to npm"
  npm whoami >/dev/null 2>&1 || npm login
  npm publish --access public
fi

say "Done: https://github.com/$OWNER/$REPO"
cat <<EOF

Install commands for others:
  Claude Code:  /plugin marketplace add $OWNER/$REPO
                /plugin install ambition-lenses@ambition-lenses
  pi:           pi install git:github.com/$OWNER/$REPO
  Any agent:    npx skills add $OWNER/$REPO
EOF
