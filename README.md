# BruteForceVHDL
Rock 'Em Sock 'Em game written in VHDL

Our goal was to bring back to the nostalgic game from 1964, Rock 'Em Sock 'Em.
Functionality:
- Start menu before fighting
- Take input control from user through keyboard
- Process input to decide whether user will land punch or not
- Have computer controlled opponent (CPU)
- Have background ("fight") music playing (in progress)
- Output still images and animations through VGA for better UX
- End battle after timer ends or health depletes

Specifications
- Keyboard (PS2)
    - user input
- Audio Amplifier
    - background music
- VGA Display
    - Display game elements (Health, Fighter Animations and Stills)
- Game Mechanics
    - LFSR, Adjusted Clock implementation for CPU attacks, Probability of Punches landing
- Seven Segment Display
    - Game Timer
