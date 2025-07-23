#!/bin/bash
set -e

echo "📦 Stashing changes (including untracked)..."
git stash push -u -m "temp-stashed"

echo "⬇️ Pulling with rebase..."
git pull --rebase

echo "📤 Popping stash..."
git stash pop

echo "➕ Staging changes matching pattern: ${FILE_PATTERN}"
git add "${FILE_PATTERN}"

echo "📝 Committing with message: $COMMIT_MESSAGE"
GIT_AUTHOR="${COMMIT_USER_NAME} <${COMMIT_USER_EMAIL}>"
git config user.name "${COMMIT_USER_NAME}"
git config user.email "${COMMIT_USER_EMAIL}"

git commit --author="$GIT_AUTHOR" -m "$COMMIT_MESSAGE"

RETRY_COUNT=0
echo "🚀 Attempting to push..."
until git push; do
  if [ "$RETRY_COUNT" -ge "$MAX_RETRIES" ]; then
    echo "❌ Push failed after $MAX_RETRIES attempts."
    exit 1
  fi

  echo "🔁 Push failed. Rebasing again (attempt $((RETRY_COUNT + 1))/$MAX_RETRIES)..."
  git pull --rebase || {
    echo "❌ Rebase failed."
    exit 1
  }

  RETRY_COUNT=$((RETRY_COUNT + 1))
  echo "🔁 Retrying push (attempt $RETRY_COUNT)..."
done

echo "✅ Push successful!"
