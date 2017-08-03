# centralize-git-repo
Copy git repo to a new server bash script

Takes the name of a git repo and a remote git server
Copies a bare version of the repo to the server, and adds it as
remote to the loca git repo

e.g.: 

    $ centralize-git-repo.sh arepo user@gitserver:/srv/git


Generates folder in `server:/srv/git/arepo.git` and adds the remote in
local repo.

Based in <https://simpleit.rocks/creating-a-git-server-from-a-git-repo/>.

