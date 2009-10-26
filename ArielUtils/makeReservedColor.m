%function reservedColor=makeReservedColor
%
%Makes a reservedColor struct which has the following:
%<reservedColor.name> which has the names of the colors
%<reservedColor.fbVal> which has serial numbers 0=>numOfColors
%<reservedColor.gunVal> is the [r g b] value for that color
%With the following values:'background' (which is grey),'black',
%'red', 'white', 'green' 'blue'
%
%11/20/2006 ASR wrote it
%

function reservedColor=makeReservedColor

reservedColor.name={'background' 'black' 'white' 'red' 'green' 'blue'};
reservedColor.fbVal={0 1 2 3 4 5};
reservedColor.gunVal={[130 130 130]...
                      [0 0 0]...
                      [255 255 255]...
                      [255 0 0]...
                      [0 255 0]...
                      [0 0 255]...
                      };

