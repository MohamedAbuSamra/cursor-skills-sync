# Push to GitHub

If `git push` fails with **Permission denied**:

1. **Use the repo owner account**  
   Ensure Git is using the GitHub user that owns the repo (e.g. MohamedAbuSamra):
   - GitHub CLI: `gh auth login` and choose the right account.
   - Or use a Personal Access Token (PAT) for that account when Git asks for a password.

2. **Or add your account as collaborator**  
   On GitHub: repo → Settings → Collaborators → add the account you use (e.g. abusamra14) with Write access.

Then from this folder:

```bash
git push origin main
```
