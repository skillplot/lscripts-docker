# Get the current time in epoch format
current_time=$(date +%s)

# Calculate the epoch time of 2 hours ago
two_hours_ago=$((current_time - 7200))

# Filter the history for commands executed in the last two hours
history | awk -v start="${two_hours_ago}" -v end="${current_time}" '{ if ($2 >= start && $2 <= end) print }' | \
  awk '{print strftime("%Y-%m-%d %H:%M", $2), $3}' | sort | uniq -c
