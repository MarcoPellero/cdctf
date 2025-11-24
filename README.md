# Cdctf
This is a simple tool to quickly cd into folders by their name without remembering their path; I use it during CTFs to cd into challenge or ctf folders because I'm too lazy to type out the whole path

It works on the asumption that you have one folder where you dump all folders about ctfs and challenges; for example I have a folder that contains a folder for each ctf that contain a folder for each challenge

For most people this (putting it in your .bashrc; props @Loldemort) would be enough, and is maybe what I would reccomend, since this tool is better but it's also way overkill:
```bash
function cdctf() {
    cd <your ctf folder>
    DEST=$(find . -type d -name $1 -print -quit)
    if [ ! -z $DEST ]; then
        cd $DEST
    else
        echo "Folder not found"
    fi
}
```

But I was very annoyed that if I mistyped the folder name or I ran it 'dry' just to get in the main folder it ran very slow, because it has to search all of the subfolders before being certain that it has failed.
For me, this ran in 100ms, which is basically nothing but it feels like a stutter to me

This tool does the same thing but it runs instantly even if it fails. It works by using `locate` (`plocate`), a tool that finds files by pattern based on a pre-generated database. By default it runs on a system-wide database that is updated every day,
meaning that if you created a ctf folder and tried using this to find it it would fail until a day after you created it. The database can be updated manually with `updatedb` but doing so for the system-wide one is very slow, 5s~ on my computer.

Luckily `locate`/`updatedb` lets you create alternative databases that only scan certain folders, and this tool uses this to keep a database of only your main ctf folder, which is much faster to update (200ms~ on my computer).
But still, updating it every so often, even every 5s~, is inefficient and would still make it be not up to date for a little bit. This tool uses `inotify` to only update the database when new files or folders are created in the main ctf folder.
This scanner/updater has to run in the background and for that I use `systemd` and register it as a boot time service

#  Usage
Clone the repository, `cd` into it and rup `sudo ./setup.sh <path to your main ctf folder>`. This will setup some data at `/usr/share/cdctf` to remember where the main folder is and to store the `locate` database,
and it will start and register the `systemd` service to run at boot time.

Then, add `source <path to the repo>/cdctf.sh` to your .bashrc to always have access to the main command, which you can use like this: `cdctf <ctf/challenge name>` (eg. `cdctf stack-jet`).
You can also use a partial path if the folder name is too vague, for example: `cdctf cc/binary/stack-jet`
