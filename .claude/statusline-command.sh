#!/bin/bash
# Claude Code status line (2-3 line layout)
# Line 1: [model] 📁 folder | 🌿 branch
# Line 2: [ctx bar] ctx% | 🕔 5h% | 🗓️ week% | 💸 cost | vX.Y.Z
# Line 3: 🗂️ dir1, dir2, ...  (only when added_dirs is non-empty)

input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd')

# ── Folder name (basename of cwd) ──────────────────────────────────────────
folder=$(basename "$cwd")

# ── Git branch ─────────────────────────────────────────────────────────────
git_branch=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)

# ── Model display name ─────────────────────────────────────────────────────
model=$(echo "$input" | jq -r '.model.display_name // empty')

# ── Line 1 ─────────────────────────────────────────────────────────────────
# [model] 📁 folder | 🌿 branch
line1=""
[ -n "$model" ] && line1="\033[35m[${model}]\033[0m "
line1="${line1}📁 \033[36m${folder}\033[0m"
if [ -n "$git_branch" ]; then
    line1="${line1} \033[90m|\033[0m 🌿 \033[32m${git_branch}\033[0m"
fi

# ── Context bar ────────────────────────────────────────────────────────────
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used_pct" ]; then
    used_int=$(printf "%.0f" "$used_pct")
    # 10-char bar
    filled=$(( used_int / 10 ))
    empty=$(( 10 - filled ))
    bar=""
    for i in $(seq 1 $filled); do bar="${bar}█"; done
    for i in $(seq 1 $empty);  do bar="${bar}░"; done
    # Color by usage level
    if [ "$used_int" -ge 80 ]; then
        bar_color="\033[31m"
    elif [ "$used_int" -ge 50 ]; then
        bar_color="\033[33m"
    else
        bar_color="\033[32m"
    fi
    ctx_part="${bar_color}${bar} ${used_int}%\033[0m"
else
    ctx_part=""
fi

# ── Rate limits (subscription only) ────────────────────────────────────────
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

five_part=""
if [ -n "$five_pct" ]; then
    five_int=$(printf "%.0f" "$five_pct")
    if [ "$five_int" -ge 80 ]; then
        fc="\033[31m"
    elif [ "$five_int" -ge 50 ]; then
        fc="\033[33m"
    else
        fc="\033[36m"
    fi
    five_part="🕔 ${fc}${five_int}%\033[0m"
fi

week_part=""
if [ -n "$week_pct" ]; then
    week_int=$(printf "%.0f" "$week_pct")
    if [ "$week_int" -ge 80 ]; then
        wc="\033[31m"
    elif [ "$week_int" -ge 50 ]; then
        wc="\033[33m"
    else
        wc="\033[36m"
    fi
    week_part="🗓️  ${wc}${week_int}%\033[0m"
fi

# ── API cost (official total from stdin, shown when no subscription rate limits) ──
cost_part=""
if [ -z "$five_pct" ] && [ -z "$week_pct" ]; then
    total_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
    if [ -n "$total_cost" ]; then
        cost_fmt=$(printf "$%.4f" "$total_cost" 2>/dev/null || echo "\$${total_cost}")
        cost_part="💸 \033[36m${cost_fmt}\033[0m"
    fi
fi

# ── Claude Code version ────────────────────────────────────────────────────
version=$(echo "$input" | jq -r '.version // empty')
version_part=""
[ -n "$version" ] && version_part="\033[90mv${version}\033[0m"

# ── Line 2: assemble with " | " separators ──────────────────────────────────
line2=""
for part in "$ctx_part" "$five_part" "$week_part" "$cost_part" "$version_part"; do
    if [ -n "$part" ]; then
        if [ -n "$line2" ]; then
            line2="${line2} \033[90m|\033[0m ${part}"
        else
            line2="${part}"
        fi
    fi
done

# ── Line 3: added directories ───────────────────────────────────────────────
line3=""
added_dirs_json=$(echo "$input" | jq -r '.workspace.added_dirs // [] | .[]' 2>/dev/null)
if [ -n "$added_dirs_json" ]; then
    dir_names=""
    while IFS= read -r dir_path; do
        [ -z "$dir_path" ] && continue
        base=$(basename "$dir_path")
        if [ -n "$dir_names" ]; then
            dir_names="${dir_names}, ${base}"
        else
            dir_names="${base}"
        fi
    done <<< "$added_dirs_json"
    [ -n "$dir_names" ] && line3="🗂️  \033[36m${dir_names}\033[0m"
fi

# ── Output ──────────────────────────────────────────────────────────────────
printf "%b\n" "$line1"
[ -n "$line2" ] && printf "%b\n" "$line2"
[ -n "$line3" ] && printf "%b\n" "$line3"
exit 0
