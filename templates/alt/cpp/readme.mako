<%! 
import filters.csharp as filters
%>

% for fd in root.federates.values(): 
/### آموزش استفاده از کد تولید شده در زبان C++

- باید فایل کتابخانه ای مناسب در کنار برنامه باشد

/## راه اندازی اولیه - اجرای پروژه

- یک ترمینال باز کنید و وارد مسیر پروژه شوید.
- به پوشه build بروید.
- دستورات زیر را اجرا کنید.

cmake ..
make -j
./${fd.name|filters.cap}

- پروژه با موفقیت ران شد.

ALMAS-FILE-INFO
alt/cpp/${fd.name|filters.cap}/readMe.txt
ALMAS-FILE-SEPRATE
% endfor
