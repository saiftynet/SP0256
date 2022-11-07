7# SP0256
Allophone speech synthesis in Pure Perl. Multiple methods of getting Perl applications to speak are available.  As far as I can tell all use external libraries to do the heavy lifting. I want to try and implement one with near-zero external dependencies, mainly for simple recognisable speech audio in games etc. Thought I'd start with the classic SP0256 chip as a starting point in this exploration. 

This modulino includes a transformation engine that translates text to allophones.  

[SP0256.webm](https://user-images.githubusercontent.com/34284663/199564715-6f7166c4-04fb-4ff9-876b-60613887959c.webm)

The allophones are rather distorted, and the source I used (from a Github repo of ExtremeEectronis) appears to be also derived from an innaccurate source acording to the author.  It would be an idea to evaluate how different from natural sounds these allophones are, certainly there are allophones in thgis set that, at least to my ear do not sound quite the way one might expect.  Hence a console based audio analyser...

[AudioAnalyser.webm](https://user-images.githubusercontent.com/34284663/200185500-67eed845-cce0-4195-b6c1-81937a972edf.webm)

Note: this Analyser needs Term::Graille v0.15 at least

### DISCLAIMER

I am not a expert in phonetics, linguistics or audio data analysis.  I also happen to be more tone deaf than an earwig with no ears.  So apologies for any offense I cause with my lack of knowledge and insight in this field.

### Changes 

* version 0.03 has an experimental Windows version requiring Win32::Sound 

### Reading List
[Sample rate conversion](https://www.psaudio.com/copper/article/sample-rate-conversion/)

[A Source of C  Allophone data](https://github.com/ExtremeElectronics/SP0256-AL2-Pico-Emulation-Detail)  This is derived form a source which is known to be innaccurate;  a more accurate allophone set would be nice

[An IP Telephone](https://www.foo.be/docs/tpj/issues/vol5_3/tpj0503-0002.html)

[PLOYTEC](https://www.ploytec.com/pl2/pl02_56_release_notes.pdf) has a useful dictionary and gives a good insight on how to maximise the yield with the chip.

[p5-NRL-TextToPhoneme](https://github.com/greg-kennedy/p5-NRL-TextToPhoneme) by [Greg Kennedy](https://greg-kennedy.com/) 

[Original ROMs](https://k1.spdns.de/Vintage/Sinclair/82/Peripherals/Currah%20uSpeech/Technical%20Information/)

[Allophonic Rules](https://youtu.be/vaRTzIoEp9k)

[Software waveforms](https://swphonetics.com/praat/tutorials/understanding-waveforms/speech-waveforms)

[Waveforms of Speech](https://www.mq.edu.au/about/about-the-university/our-faculties/medicine-and-health-sciences/departments-and-centres/department-of-linguistics/our-research/phonetics-and-phonology/speech/acoustics/speech-waveforms/the-waveforms-of-speech) by [Robert Mannell](https://www.researchgate.net/profile/Robert-Mannell-2) at MacQuarie University

