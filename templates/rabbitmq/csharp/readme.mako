<%! 
import filters.csharp as filters
%>

% for fd in root.federates.values(): 
/### آموزش استفاده از کد تولید شده در زبان C#

/## راه اندازی اولیه - ساخت پروژه

- برنامه Visual Studio را باز کنید و روی ایجاد یک پروژه جدید کلیک کنید.
- از بین تمپلیت ها گزینه Console application را با زبان سی شارپ انتخاب کنید.
- دقت کنید که حتما باید نسخه دات نت 4.8.1 یا بالا تر را انتخاب کنید.
- بعد از ایجاد پروژه باید فایل های تولید شده را در محل پروژه جایگذاری کنید.
- سپس مجدد وارد برنامه شوید و از منوی اکسپلورر فایل های اضافه شده را انتخاب کرده و روی گزینه Include to project بزنید.

/## راه اندازی اولیه - نصب پیش نیاز ها

- حالا باید پکیج های مورد نیاز را نصب کنید. برنامه به دو پکیج زیر نیاز دارد:
- https://www.nuget.org/packages/System.Text.Json
- https://www.nuget.org/packages/RabbitMQ.Client/6.8.1

- بدین منظور پکیج منیجر برنامه Visual studio را باز کنید و دستورات زیر را وارد کنید:
NuGet\Install-Package System.Text.Json -Version 8.0.5
NuGet\Install-Package RabbitMQ.Client -Version 6.8.1

- حالا پروژه آماده کامپایل شدن است.

/## راه اندازی اولیه - اجرای پروژه

- روی گزینه Run کلیک کنید تا پروژه اجرا شود.
- آخرین مرحله برای اجرای صحیح کپی فایل config.json در محل ایجاد خروجی است. بدین منظور این فایل را در مسیر bin/debug کپی کنید. (این مسیر می تواند بسته به نوع خروجی متفاوت باشد)
- حالا می توانید پروژه را اجرا کرده و از آن استفاده کنید.

ALMAS-FILE-INFO
rabbitmq/csharp/${fd.name|filters.cap}/readMe.txt
ALMAS-FILE-SEPRATE
% endfor
