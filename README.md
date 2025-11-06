# راهنمای اجرای تمرین‌های عملی سیستم عامل

## پیش‌نیازها

- سیستم عامل لینوکس (ترجیحاً Ubuntu/Debian)
- کامپایلر GCC/G++
- ابزار perf (معمولاً با دستور زیر نصب می‌شود):
  ```bash
  sudo apt-get install linux-perf
  ```
- ابزار tracey (برای نصب دستورالعمل‌های مربوطه را ببینید)

## تمرین ۱: Fork Bomb

### ۱. کامپایل و اجرا
```bash
gcc -o fork_bomb fork_bomb.c
./fork_bomb
```

**⚠️ هشدار**: این برنامه سیستم را دچار مشکل می‌کند! فقط در ماشین مجازی اجرا کنید.

### ۲. متوقف کردن Fork Bomb
در ترمینال دیگری (یا از طریق SSH):
```bash
chmod +x stop_fork_bomb.sh
./stop_fork_bomb.sh
```

یا به صورت دستی:
```bash
pkill -9 fork_bomb
# یا
killall -9 fork_bomb
```

### ۳. بررسی منابع سیستم
```bash
# مشاهده تعداد پردازه‌ها
ps aux | wc -l

# مشاهده استفاده از CPU و حافظه
top
# یا
htop
```

## تمرین ۲: تحلیل عملکرد با perf

### ۱. اجرای تحلیل اولیه
```bash
chmod +x run_perf_analysis.sh
./run_perf_analysis.sh
```

### ۲. تولید FlameGraph
```bash
chmod +x generate_flamegraph.sh
./generate_flamegraph.sh
```

برای مشاهده FlameGraph:
```bash
# اگر در محیط گرافیکی هستید
xdg-open flamegraph_before.svg

# یا از مرورگر استفاده کنید
firefox flamegraph_before.svg
```

### ۳. استفاده از tracey
```bash
# نصب tracey (اگر نصب نشده)
# دستورالعمل‌های نصب را در مستندات tracey ببینید

# اجرای tracey
tracey ./performance_test
```

## تمرین ۳: بهینه‌سازی برنامه

بعد از شناسایی بخش‌های نابهینه با FlameGraph، برنامه را بهینه کنید و دوباره تحلیل کنید.

## نکات مهم

1. **همیشه از ماشین مجازی استفاده کنید** برای تمرین Fork Bomb
2. قبل از اجرای Fork Bomb، محدودیت‌های ulimit را بررسی کنید:
   ```bash
   ulimit -u 100  # محدود کردن تعداد پردازه‌ها
   ```
3. برای تحلیل دقیق‌تر، از فلگ‌های بهینه‌سازی مناسب استفاده کنید
4. نتایج را در فایل HW1.tex ثبت کنید

