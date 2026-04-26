# ============================================================
# ENVIRONMENT
# ============================================================
set -x EDITOR code
set -x VISUAL code
set -x PAGER less
set -x LESS '-R --mouse'
set -x HISTSIZE 100000
set -x ghcr "ghcr.io/muhammedemineser/"
set -x brc "$HOME/.config/fish/config.fish"
set -x PATH $PATH $HOME/go/bin

# Cargo
if test -f "$HOME/.cargo/env"
    set -x PATH $PATH $HOME/.cargo/bin
end

# Starship
starship init fish | source

# Zoxide
zoxide init fish | source

# ============================================================
# GIT
# ============================================================
alias gadd='git add .'
alias gaddcm='git add . && git commit --amend --no-edit'
alias gpsh='git push'
alias gpl='git pull'
alias gst='git status'
alias gl='git log --oneline --graph --decorate'
alias gcheck='git checkout'
alias glog='git log -1'
alias gdiff='git diff'
alias greset='git reset --soft HEAD~1'
alias gamend='git commit --amend --no-edit'
alias grestore='git restore --staged .'
alias gfetch='git fetch'
alias gpull='git pull'

function gcm
    git commit -m "$argv"
end

function gchm
    git commit --amend -m "$argv"
end

# ============================================================
# NAVIGATION
# ============================================================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ============================================================
# LS
# ============================================================
alias l='ls -CF --color=auto'
alias la='ls -A --color=auto'
alias ll='ls -alFh --color=auto'
alias lsa='ls -A'
alias lsl='ls -alF --group-directories-first'
alias lst='ls -alF --group-directories-first --time-style=long-iso'
alias ls='ls -CF --color=auto'

# ============================================================
# SYSTEM
# ============================================================
alias cls='clear'
alias upd='sudo apt update && sudo apt upgrade -y'
alias exp='nautilus .'
alias src='source'
alias scr='flameshot gui'
alias sht='sudo systemctl poweroff'
alias ssn='sudo shutdown -h now'
alias off='systemctl suspend'
alias off_long='systemctl suspend-then-hibernate'
alias offbg='xset dpms force off'
alias psa='ps aux'
alias h='head'
alias t='tail'
alias dfh='df -h'
alias duh='du -h --max-depth=1'
alias wh='type -a'
alias keyevent='sudo libinput debug-events'
alias cx='chmod +x'
alias ex='exit'
alias pwda='realpath'
alias hg='history | grep'
alias psg='ps aux | grep -v grep | grep'
alias tree='tree -C'

# ============================================================
# EDITORS
# ============================================================
alias nv='nvim'
alias brc='nvim ~/.config/fish/config.fish'
alias srcrc='source ~/.config/fish/config.fish'
alias c='code .'
alias mark='~/Downloads/marktext-x86_64.AppImage --disable-gpu --no-sandbox'

# ============================================================
# GREP / RIPGREP
# ============================================================
alias g='grep --color=auto'
alias gi='grep -i --color=auto'
alias gn='grep -n --color=auto'
alias rg='rg --smart-case'
alias se='sed -E'
alias a='awk'
alias xa='xargs -r -n 1'
alias xp='xargs -P (nproc) -n 1'

# ============================================================
# PYTHON
# ============================================================
alias py='python3'
alias pip='pip3'
alias python='python3'
alias venv='python3 -m venv .venv'
alias venva='source .venv/bin/activate.fish'
alias venvd='deactivate'

# ============================================================
# PIPENV
# ============================================================
alias pe='pipenv'
alias pei='pipenv install'
alias ped='pipenv install --dev'
alias per='pipenv run'
alias pes='pipenv shell'
alias pelu='pipenv lock -u'
alias pecl='pipenv clean'
alias penew='pipenv --python3 3.11'
alias petest='pipenv run pytest'
alias perp='pipenv run python'

# ============================================================
# DJANGO
# ============================================================
alias dj='pipenv run python3 manage.py'
alias djrun='pipenv run python3 manage.py runserver'
alias djmm='pipenv run python3 manage.py makemigrations'
alias djm='pipenv run python3 manage.py migrate'
alias djshell='pipenv run python3 manage.py shell'
alias djtestall='pipenv run pytest -n 8'
alias djsuperuser='python3 manage.py createsuperuser'
alias cdp='cd project'
alias afuzz='cd /home/muhammed-emin-eser/desk/p/PrintZ && pipenv run python3 /home/muhammed-emin-eser/desk/p/PrintZ/scripts/analyze_fuzz_log.py'
alias fuzz='cd /home/muhammed-emin-eser/desk/p/PrintZ/project && pipenv run python3 manage.py fuzz_endpoints > /home/muhammed-emin-eser/desk/p/PrintZ/project/logs/run_001.log'
alias stripelistenprintz='stripe listen --forward-to http://localhost:8000/payments/stripe/webhook/'
alias printz='code ~/desk/p/PrintZ'
alias app='pipenv run uvicorn app:app --reload'

function djtest
    pipenv run pytest project/$argv
end

# ============================================================
# AUDIO / BLUETOOTH
# ============================================================
alias mic='pactl set-card-profile bluez_card.31_11_72_51_E1_F9 headset-head-unit-msbc'
alias hifi='pactl set-card-profile bluez_card.31_11_72_51_E1_F9 a2dp-sink'
alias quran='mpv --shuffle /home/muhammed-emin-eser/desk/din/quran/maher_playlist'

function sp
    set WAV "mic.wav"
    set TSV "mic.tsv"
    set CARD "bluez_card.31_11_72_51_E1_F9"
    set SRC "bluez_input.31_11_72_51_E1_F9.0"
    cd /home/muhammed-emin-eser/desk/apps/whisper

    function cleanup --on-signal INT
        echo "Aufnahme gestoppt, schalte zurück auf HiFi..."
        pactl set-card-profile $CARD a2dp-sink
        echo "Starte Whisper (nur TSV-Output)..."
        pipenv run whisper --model small --language de --task transcribe \
            --output_format tsv --output_dir . $WAV
        echo "Warte auf $TSV..."
        for i in (seq 1 100)
            test -f $TSV && break
            sleep 0.1
        end
        if test -f $TSV
            echo "Transkript gefunden."
            sed '1d; s/^\S*\t\S*\t//' $TSV | xclip -selection clipboard
            echo "In Zwischenablage kopiert (xclip)."
            rm -f $WAV $TSV
            echo "Temporäre Dateien entfernt."
        else
            echo "Kein Transkript gefunden."
            rm -f $WAV
        end
    end

    echo "Aufnahme läuft... Strg+C zum Beenden"
    pactl set-card-profile $CARD headset-head-unit-msbc
    ffmpeg -f pulse -i $SRC $WAV
end

# ============================================================
# DOCKER
# ============================================================
alias dls='sudo ls -l /var/lib/docker/containers/'
alias dimg='docker images'
alias dcm='docker commit'
alias dpull='docker pull'
alias tm='tmux'
alias sqlb='sqlitebrowser'
alias pids='ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 20'
alias pypids="ps -u \$USER -o pid,pcpu,args --sort=-%cpu | grep -E 'python[0-9.]* ' | grep -v 'vscode' | column -t"

function dbuild
    docker build -t $argv[1] .
end

function ddev
    set project $argv[1]
    set module $argv[2]
    set env_arg ""
    if test -f .env
        set env_arg "--env-file .env"
    end
    docker run --rm $env_arg -v (pwd):/app $project $module
end

function dbash
    set image $argv[1]
    set env_arg ""
    if test -f .env
        set env_arg "--env-file .env"
    end
    docker run --rm -it $env_arg --entrypoint /bin/bash $image
end

function ddel
    if test -z $argv[1]
        echo "Benutzung: ddel <image_tag_oder_id>"
        return 1
    end
    docker ps -a | grep $argv[1] | awk '{print $1}' | xargs -r docker rm -f
    docker rmi -f $argv[1]
    docker image prune -f
end

function drun
    set image $argv[1]
    if test -z $image
        set image "classify-test:local"
    end
    set rest $argv[2..-1]
    set env_arg ""
    if test -f .env
        set env_arg "--env-file .env"
    end
    if test (count $rest) -eq 0
        docker run --rm $env_arg $image
    else
        docker run --rm $env_arg --entrypoint /usr/local/bin/python $image $rest
    end
end

function drelease
    set project $argv[1]
    set gh_user muhammedemineser
    set target_img "ghcr.io/$gh_user/$project"
    echo "Starte Build & Push für: $target_img"
    docker build -t $project . &&
        docker tag $project $target_img &&
        docker push $target_img
end

function dpush
    set image $argv[1]
    set gh_user muhammedemineser
    set target_img "ghcr.io/$gh_user/$image"
    echo "Pushing: $target_img"
    docker tag $image $target_img &&
        docker push $target_img
end

function dcls
    if test -z $argv[1]
        echo "Fehler: Bitte gib einen Image-Namen an."
        return 1
    end
    docker run -it --rm --entrypoint /bin/ls $argv[1] -la
end

function dcex
    if test (count $argv) -lt 2
        echo 'Benutzung: dcex [image_tag] [befehl] [argumente...]'
        return 1
    end
    set image $argv[1]
    set cmd $argv[2..-1]
    docker run -it --rm --entrypoint /bin/bash $image -c "$cmd"
end

function dcmloop
    set container_id $argv[1]
    set image_name $argv[2]
    if test -z $container_id -o -z $image_name
        echo "Nutzung: dcmloop <container> <image>"
        return 1
    end
    echo "Starte Autocommit für '$container_id' -> '$image_name' (Intervall: 5 Min)."
    while true
        if not docker ps --format '{{.Names}} {{.ID}}' | grep -q $container_id
            echo (date +'%H:%M:%S')" - ⚠️  Container '$container_id' nicht gefunden."
        else
            if docker commit $container_id $image_name >/dev/null
                echo (date +'%H:%M:%S')" - ✅ Backup-Commit erfolgreich."
            else
                echo (date +'%H:%M:%S')" - ❌ Fehler beim Commit."
            end
        end
        sleep 300
    end
end

function dcmloopseq
    set container_id $argv[1]
    set base_image_name $argv[2]
    if test -z $container_id -o -z $base_image_name
        echo "Nutzung: dcmloopseq <container> <image>"
        return 1
    end
    set i (docker images --format '{{.Tag}}' $base_image_name | grep -E '^[0-9]+$' | sort -nr | head -n1)
    if test -z $i
        set i 0
    end
    echo "Starte Autocommit-Sequenz. Nächster Index: "(math $i + 1)
    while true
        set i (math $i + 1)
        set current_tag "$base_image_name:$i"
        if not docker ps --format '{{.ID}}' | grep -q (docker inspect -f '{{.Id}}' $container_id 2>/dev/null)
            echo (date +'%H:%M:%S')" - ⚠️  Container nicht aktiv."
            set i (math $i - 1)
        else
            if docker commit $container_id $current_tag >/dev/null
                echo (date +'%H:%M:%S')" - ✅ Commit: $current_tag"
            else
                echo (date +'%H:%M:%S')" - ❌ Fehler bei Commit $i"
                set i (math $i - 1)
            end
        end
        sleep 300
    end
end

function dapiruns
    docker run --rm -it --name dev --entrypoint /bin/bash \
        --mount type=bind,dst=/app/Tafsir/pipeline/gemini_api/blocks_to_xml_api.py,src=/home/muhammed-emin-eser/desk/projects/classify_mount/blocks_to_xml_api.py \
        --mount type=bind,src=/home/muhammed-emin-eser/desk/projects/classify_mount/SWITCH_MODEL.py,dst=/app/Tafsir/pipeline/gemini_api/SWITCH_MODEL.py \
        --mount type=bind,src=/home/muhammed-emin-eser/desk/projects/classify_mount/katheer_annotated.sqlite3,dst=/app/Tafsir/tafsir_books_annotated/katheer_annotated.sqlite3 \
        $argv[1]
end

# ============================================================
# MISC TOOLS
# ============================================================
alias pymo='cd /home/muhammed-emin-eser/desk/apps/classify && python3 run_active_as_module.py'
alias classify='code ~/desk/apps/classify'
alias cdxwatcher='cd ~/desk/apps/Codex_watcher && pipenv run python3 codex_idle_alert_loud.py'
alias cdxstart="$HOME/desk/apps/Codex_watcher/start_cdxwatcher.sh"
alias cdxstop="$HOME/desk/apps/Codex_watcher/stop_cdxwatcher.sh"
alias cpout='xclip -selection clipboard'
alias gui='sudo /usr/local/bin/gui-temporary.sh'
alias headless='sudo /usr/local/bin/headless-mode.sh'
alias back-tty='sudo systemctl isolate multi-user.target && sudo systemctl stop sddm'
function runClassifyApi
    set WAIT 600
    while true
        echo "--- Start: (date) ---"
        python3 -u main.py api 2>&1 | tee /tmp/current_run.log
        if grep -q "Erfolg:" /tmp/current_run.log
            echo "Erfolg. Reset auf 10 Min."
            set WAIT 600
        else
            echo "Kein Erfolgssignal. Warte $WAIT Sek..."
            sleep $WAIT
            set WAIT (math $WAIT \* 2)
        end
    end
end
alias cckill="ps aux | g cchv-server | awk '{ print \$1 }' | head -n 1 | xa kill -9"
alias cc="cchv-server --serve --no-auth & sleep 2; echo 'PID: \$!';"
alias kp="ps aux | g peep.py | awk '{ print \$2 }' | xa kill -9"
alias qq='/home/muhammed-emin-eser/utils/run-qq-server.sh'

function img
    echo "$ghcr$argv[1]"
end

function extract
    switch $argv[1]
        case '*.tar.bz2'
            tar xjf $argv[1]
        case '*.tar.gz'
            tar xzf $argv[1]
        case '*.bz2'
            bunzip2 $argv[1]
        case '*.rar'
            unrar x $argv[1]
        case '*.gz'
            gunzip $argv[1]
        case '*.tar'
            tar xf $argv[1]
        case '*.tbz2'
            tar xjf $argv[1]
        case '*.tgz'
            tar xzf $argv[1]
        case '*.zip'
            unzip $argv[1]
        case '*.Z'
            uncompress $argv[1]
        case '*.7z'
            7z x $argv[1]
        case '*'
            echo "extract: unbekanntes Format: $argv[1]"
    end
end

function f
    set path $argv[1]
    if test -z $path
        set path "."
    end
    set type $argv[2]
    set name $argv[3]
    if test -z $name
        set name "*"
    end
    switch $type
        case f
            find $path -type f -name $name
        case d
            find $path -type d -name $name
        case l
            find $path -type l -name $name
        case '*'
            find $path -name $name
    end
end

function ptree
    pstree -aps (pgrep -n $argv[1])
end

function findir
    set files $argv[1]/*
    echo (count $files)
end

function shorts
    echo "alias $argv[1]=$argv[2]" >>~/.config/fish/config.fish
end

function s
    if test (count $argv) -lt 2
        echo "Usage: s <datei> <flags> <sed-befehl>"
        return 1
    end
    set datei $argv[1]
    set flags $argv[2]
    set befehl $argv[3..-1]
    echo "Änderungen in $datei:"
    sed $flags $befehl $datei
    echo "Möchten Sie die Änderungen anwenden? (j/n)"
    read antwort
    if test $antwort = j
        sed -i $flags $befehl $datei
        echo "Änderungen wurden angewendet."
    else
        echo "Änderungen wurden abgebrochen."
    end
end

function piploop
    set script $argv[1]
    if test -z $script
        echo "Fehler: Kein Skript angegeben."
        return 1
    end
    while true
        set output (python $script 2>&1)
        set exit_code $status
        if string match -q "*ModuleNotFoundError: No module named*" $output
            set pkg (string match -r "No module named '([^']+)'" $output)[2]
            echo "⚠️  Installiere: $pkg"
            uv pip install $pkg -q
            continue
        end
        if string match -q "*Install with: pip install*" $output
            set pkg (string match -r "pip install ([a-zA-Z0-9_-]+)" $output)[2]
            echo "⚠️  Installiere: $pkg"
            uv pip install $pkg -q
            continue
        end
        if test $exit_code -eq 0
            echo "✅ Skript erfolgreich."
        else
            echo $output
        end
        return $exit_code
    end
end

function claude-cat
    if test -z $argv[1]
        echo "Usage: claude-cat <path-to-jsonl>"
        return 1
    end
    python3 -c "
import json, sys
path = sys.argv[1]
try:
    with open(path, 'r', encoding='utf-8') as f:
        for line in f:
            try:
                obj = json.loads(line)
                role = obj.get('type')
                if role not in ['user', 'assistant']:
                    continue
                message = obj.get('message', {})
                content = message.get('content', '')
                if isinstance(content, list):
                    text = ' '.join(c.get('text', '') for c in content if isinstance(c, dict) and c.get('type') == 'text')
                elif isinstance(content, str):
                    text = content
                else:
                    text = ''
                if text.strip():
                    color = '\033[94m' if role == 'user' else '\033[92m'
                    reset = '\033[0m'
                    print(f'{color}[{role.upper()}]{reset}\n{text.strip()}\n')
            except json.JSONDecodeError:
                continue
except FileNotFoundError:
    print(f'Error: File {path} not found.')
" $argv[1]
end

# ============================================================
# NVIM-REMOTE — open files in outer nvim from :terminal buffer
# ============================================================
function nvim
    if set -q NVIM
        nvr --remote $argv
    else
        command nvim $argv
    end
end

# cd/z write CWD to file on success → kitty new tab inherits location
function cd
    builtin cd $argv
    and echo $PWD > /tmp/kitty_last_cwd
end

function z
    __zoxide_z $argv
    and echo $PWD > /tmp/kitty_last_cwd
end

# Safe defaults
alias rm='rm -i'
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -iv'
bind \ch history-pager
bind \ck history-search-backward
bind \cj history-search-forward
set -x WAYLAND_DISPLAY ""
