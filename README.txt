saveToPDF.bat saves various URLs to PDFs on a daily schedule using the Chrome headless function.

Google Chrome must be installed on the computer, but it cannot be running when the script is launched.

For each day of the month, create a .txt file with the digit of the day; for example, 13.txt

Inside 13.txt, type the name you would like the PDF file to have, and the URL. The URL must be escaped, with no spaces: spaces must be replaced with %20

For example:

wikipedia https://en.wikipedia.org/wiki/Main%20Page
mpr mprnews.org

Running the script on the 13th of the month will save wikipedia.pdf and mpr.pdf to the folder PDFs/YYYY/MM/ from where the script is run.

For example, if you run this script on November 13, 2024, from C:\Users\JSmith\Documents\Saver\saveToPDF.bat, then the documents will save to:

C:\Users\JSmith\Documents\Saver\PDFs\2024\11\wikipedia.pdf
C:\Users\JSmith\Documents\Saver\PDFs\2024\11\mpr.pdf

Depending on where Chrome is installed, the chromePath variable may need to be edited.