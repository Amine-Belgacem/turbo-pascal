program Welcome;
uses WinCrt; 

{\/\/\/\/\/\/\____  NEW FEATURES  ____/\/\/\/\/\/\/\/\/}

(*1* WinCrt now displays up to 256 lines instead of 25*)

(*2* New Editor shortcuts:                            *)
            {- Ctrl+S: Save     }
            {- Ctrl+C: Copy     }
            {- Ctrl+X: Cut      }
            {- Ctrl+V: Paste    }
            {- Ctrl+Z: UnDo     }
            {- Ctrl+Y: ReDo     }

(*3* Auto-Save Source file before Execution           *)
           
var i:byte;
begin
  for i:=1 to 255 Do 
    Writeln(i:3,' - Welcome to TPW 1.5');
end.