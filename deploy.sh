#!/bin/bash
set -e
export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"
cd "/Users/michaelvonhirschfeld/Documents/Work/websites/jobidai"
# Verwaistes index.lock entfernen (z.B. nach abgestuerztem git-Prozess).
# Nur loeschen, wenn gerade kein git-Prozess laeuft - sonst abbrechen.
LOCK=".git/index.lock"
if [ -f "$LOCK" ]; then
    if pgrep -x git >/dev/null 2>&1; then
        echo "Ein git-Prozess laeuft noch - bitte warten und erneut starten."
        exit 1
    fi
    rm -f "$LOCK"
    echo "Verwaistes $LOCK entfernt."
fi
DATE=$(date +"%Y-%m-%d")
TIME=$(date +"%H-%M")
EXTRA="$1"
MSG="[jobidai] Changes on $DATE at $TIME${EXTRA:+ - $EXTRA}"
if [ -z "$(git status --short)" ]; then
    echo "Nothing to deploy"
    exit 0
fi
git add -A
git commit -m "$MSG"
git push origin HEAD:main
echo "Deployed to jobid.ai: $MSG"
