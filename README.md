# SP0256
Allophone speech synthesis in Pure Perl. Multiple methods of getting Perl applications to speak are available.  As far as I can tell all use external libraries to do the heavy lifting. I want to try and implement one with near-zero external dependencies, mainly for simple recognisable speech audio in games etc. Thought I'd start with the classic SP0256 chip as a starting point in this exploration. 

This modulino includes a transformation engine that translates text to allpphones.  

### References
[Sample rate conversion](https://www.psaudio.com/copper/article/sample-rate-conversion/)

[A Source of C  Allophone data](https://github.com/ExtremeElectronics/SP0256-AL2-Pico-Emulation-Detail)  This is derived form a source which is known to be innaccurate;  a more accurate allophone set would be nice

[An IP Telephone](https://www.foo.be/docs/tpj/issues/vol5_3/tpj0503-0002.html)

[PLOYTEC](https://www.ploytec.com/pl2/pl02_56_release_notes.pdf) has a useful dictionary and gives a good insight on how to maximise the yield with the chip.

[p5-NRL-TextToPhoneme](https://github.com/greg-kennedy/p5-NRL-TextToPhoneme) by Greg Kennedy 

[Original ROMs](https://k1.spdns.de/Vintage/Sinclair/82/Peripherals/Currah%20uSpeech/Technical%20Information/)

[Allophonic Rules](https://youtu.be/vaRTzIoEp9k)
