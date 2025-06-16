# 🚀 Safe Rebase Commit & Push

A GitHub Action to safely stash changes, rebase with the latest upstream, commit staged changes, and push with retry logic

---

## ✅ Features

- Stashes uncommitted changes (including untracked files)
- Pulls the latest changes with rebase
- Pops the stash and commits staged files
- Pushes with retry logic to handle race conditions
- Supports commit identity via flags (no global Git config)
- Highly configurable: path, commit message, file patterns

---

## 📦 Usage

```yaml
- name: Commit and push
  uses: hisco/safe-rebase-commit@v1
  with:
    path: "deployment"                      # Optional — default is "."
    commit_message: "Update deployment"     # Required
    commit_user_name: "GitHub Actions Bot"  # Optional — default is "github-actions[bot]"
    commit_user_email: "actions@github.com" # Optional — default is "github-actions[bot]@users.noreply.github.com"
    file_pattern: "."                       # Optional — default is "."
    max_retries: 3                          # Optional — default is 3
```

---

## 🔧 Inputs

| Name               | Required | Default                              | Description                                   |
|--------------------|----------|--------------------------------------|-----------------------------------------------|
| `path`             | ❌        | `.`                                  | Working directory where Git operations occur. |
| `commit_message`   | ✅        | —                                    | Commit message to use.                        |
| `commit_user_name` | ❌        | `github-actions[bot]`                | Git commit author name.                       |
| `commit_user_email`| ❌        | `github-actions[bot]@users.noreply.github.com` | Git commit author email.           |
| `file_pattern`     | ❌        | `.`                                  | Files to stage for commit.                    |
| `max_retries`      | ❌        | `3`                                  | Max number of retry attempts for `git push`.  |

---

## 🛡️ Example Workflow

```yaml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Make a change
        run: echo "Update: $(date)" >> deployment/info.txt

      - name: Commit and push
        uses: hisco/safe-rebase-commit@v1
        with:
          path: "deployment"
          commit_message: "Update deployment at $(date)"
```

---

## 📄 License

MIT © hisco
