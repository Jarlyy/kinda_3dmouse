![image](https://github.com/user-attachments/assets/bf7e6154-c71a-4939-8615-8c26b5efbdd1)
This is a kinda 3d mouse project. You can make it using only arduino uno (or another arduino without HID) and two joystick moduls. It uses one joystick to rotate and another to move in CAD.

INSTRUCTIONS
1. Connect two joysticks to the Arduino as shown in this diagram
![sheme](https://github.com/user-attachments/assets/a79f6640-6c77-4e53-b852-8b5f0d97bb50)

Movement joystick:

   GND - GND
   
   5V - 5V
   
   VRX - A0
   
   VRY - A1
   
Rotation joystick:

   GND - GND

   5V - 5V
   
   VRX - A2
   
   VRY - A3

2. Upload file sketch_3dmouse.ino to your arduino via arduino IDE. Open serial monitor and chose 115200 baud. Check if arduino sends the position of the joysticks.
3. Download program AutoHotKey (https://www.autohotkey.com/?ref=website-popularity). You need to chose version 1.1
4. Download and open file fusion360_3dmouse.ahk or kompas3d_3dmouse.ahk depending on what CAD do you use. <b>Don't forget to close arduino IDE because it takes up USB port.</b>
   You can change your sensivity and usb COM port (chek it in arduino IDE) in that file. To stop that script you can press <b>ctrl + esc</b> or exit here:
   
   ![image](https://github.com/user-attachments/assets/b8911011-d019-4caa-a76b-cc86e11063c4)
5. Than you can 3d print a body (3dmouse.stl and 3dmouse_joystick_clip.stl x2). If joystick clips are to lose scale them up a litle bit.
   
   ![image](https://github.com/user-attachments/assets/e1a35365-db26-4e3a-8c30-2b1445c75bf8)

   ![image](https://github.com/user-attachments/assets/6372b273-472b-49ce-aa30-09edbe8f387f)
