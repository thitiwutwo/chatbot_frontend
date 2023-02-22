# chatbot_frontend
ทีม 7 
# เริ่มต้น
### ติดตั้ง
1. สร้างโฟล์เดอร์สำหรับการ Clone Project
2. Clone repository ไปที่เครื่อง.
    ``````````
    git clone https://github.com/thitiwutwo/chatbot_frontend.git
    ``````````
3. เปิด command line เพื่อเข้าสู่โฟล์เดอร์ของ project ที่โคลนมา
    ``````````
    // command line
    cd your/clone/project
    ``````````
4. ใช้คำสั่งเพื่อติดตั้ง dependencies ของ flutter
     ``````````
    // command line
    flutter pub get
    ``````````
### เริ่มต้นโปรเจค
    ``````````
    // command line
    flutter run --no-sound-null-safety
    ``````````
### การ commit code
1. แนะนำให้ใช้
    ``````````
    // command line
    flutter clean
    ``````````
    มันจะเคลียร์โค้ดที่เรา compile ไปแล้วตอน clone หรือ pull มันจะไม่นาน หรืออาจจะไม่ต้องทำก็ได้
2. สร้าง branch สำหรับ push งาน (หรือจะใช้ git desktop ก็ได้)
    ``````````
    git checkout -b <branch-name>
    ``````````
3. เพิ่มไฟล์ที่จะ push เข้า git
    ``````````
    git add .
    ``````````
3. เพิ่ม comment
    ``````````
    git commit -m "this is a comment"
    ``````````
4. push งาน
    ``````````
    git push origin <branch-name>
    ``````````

# Authors
Thitiwut Wongsa - Initial work