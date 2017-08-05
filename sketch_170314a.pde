import processing.serial.*;
PrintWriter output;
Serial myPort;        // The serial port
int xPos = 1;         // horizontal position of the graph
float height_old = 0;
float height_new = 0;
float inByte = 0;
boolean newData=false;
float time=0.001;
long count=0;

void setup () {
  // set the window size:
  size(1000, 400);        
  
  // List all the available serial ports
  //println(Serial.list());
  // Open whatever port is the one you're using.
  int r = int(random(999)); 
  output = createWriter( "C:\\Users\\VIKAS\\AppData\\Local\\Google\\Cloud SDK\\data\\ECGData"+r+".csv" );
  myPort = new Serial(this, Serial.list()[0], 9600);
  
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');
  // set inital background:
  background(0xff);
}


void draw () {
  // everything happens in the serialEvent()
   // at the edge of the screen, go back to the beginning:
   if(newData){
     if(count==0)
       output.println("Time"+","+"ECG 1");
     else
       output.println(time+","+inByte);
     count++;
     time+=0.001; 
     inByte = map(inByte, 0, 1023, 0, height);
     height_new = height - inByte; 
     line(xPos - 1, height_old, xPos, height_new);
     height_old = height_new;
     if (xPos >= width) {
        xPos = 0;
        background(0xff);
      } 
      else {
        // increment the horizontal position:
        xPos++;
      }
      newData=false;
   }
}
void serialEvent (Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');

  if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);
   
    // If leads off detection is true notify with blue line
    if (inString.equals("!")) { 
      stroke(0, 0, 0xff); //Set stroke to blue ( R, G, B)
      inByte = 512;  // middle of the ADC range (Flat Line)
    }
    // If the data is good let it through
    else {
      stroke(0xff, 0, 0); //Set stroke to red ( R, G, B)
      inByte = float(inString); 
     }
     
     //Map and draw the line for new data point
     
     newData=true;
     
     
  }
}