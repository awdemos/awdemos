
## Git speedup enhancements for large repos

```bash
git config --global rerere.enabled true

git push --force-with-lease

git maintenance start

git config --global column.ui auto

git config --global branch.sort -committerdate

git config core.untrackedcache true

git config core.fsmonitor true

git config --global alias.staash 'stash --all'

curl -L https://gist.githubusercontent.com/schacon/e9e743dee2e92db9a464619b99e94eff/raw/2e3ae498c2177f5974679a6ab33849cbf33b209e/better-git-branch.sh -o ~/better-git-branch.sh

git config --global alias.bb '!~/.better-git-branch.sh
```

## Source
[# So You Think You Know Git - FOSDEM 2024](https://www.youtube.com/@gitbutlerapp)]