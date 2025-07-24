# Print disk usage
echo -e "\n Disk Usage:"
df -h | grep '^/dev'

# Print RAM usage
echo -e "\n Memory Usage:"
free -h

# Print size of current directory
echo -e "\n Current Directory Size:"
du -sh .

# Check top memory consuming processes
echo -e "\n Checking for high memory-consuming processes (>100MB):"
ps -eo pid,comm,%mem,rss --sort=-rss | head -n 15 > /tmp/memcheck.txt

while read -r pid cmd mem rss; do
  if [[ "$rss" =~ ^[0-9]+$ ]]; then
    if [ "$rss" -gt 102400 ]; then  # 100 MB in KB
      echo "PID $pid ($cmd) is using $((rss/1024)) MB of memory"
    fi
  fi
done < <(tail -n +2 /tmp/memcheck.txt)

rm /tmp/memcheck.txt
