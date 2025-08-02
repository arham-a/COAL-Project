COAL_PROJECT — Typing Master Game 

Introduction
This project is a Typing Master Game developed in MASM Assembly Language using the Irvine32 library.  
It is created as part of the Computer Organization and Assembly Language (COAL) course.  
The program tests the user's typing skills by displaying random sentences and calculating their typing speed and accuracy.

---

Features
- Welcome menu with difficulty level selection:
  - 0 — Restart
  - 1 — Easy Mode
  - 2 — Hard Mode
  - 3 — Exit
- Easy mode: Short, simple sentences.
- Hard mode: Longer, complex sentences.
- Random sentence selection each time you play.
- Tracks:
  - Time taken (in seconds)
  - Characters typed
  - Typing speed (Characters Per Second)
- Accuracy check — if the typed string does not match, the user must try again.


---

How It Works
1. Welcome Menu: 
   Displays options for difficulty selection and reads user's choice using `ReadInt`.

2. Sentence Selection:  
   Generates a random number using `RandomRange` and picks a random sentence from `easyStringArray` or `hardStringArray`.

3. Timing:
   Uses `GetMSeconds` to capture start and end time, then calculates elapsed seconds.

4. Accuracy Check: 
   Compares the typed input with the displayed string using `repe cmpsb`.  
   If incorrect, prompts the user to try again.

5. Speed Calculation:  
   Typing speed = `Typed Characters / Time Taken`  
   Displays results with one decimal precision.

---

