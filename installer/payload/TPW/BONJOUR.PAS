program bonjour;
uses WinCrt; 

{\/\/\/\/\/\/\____ Nouvelles fonctionnalités ____/\/\/\/\/\/\/\/}

(*1* WinCrt maintenant affiche jusqu'à 256 lignes au lieu de 25*)

(*2* Nouveaux raccourcis clavier de l'éditeur:                 *)
            {- Ctrl+S: Enregistrer     }
            {- Ctrl+C: Copier          }
            {- Ctrl+X: Couper          }
            {- Ctrl+V: Coller          }
            {- Ctrl+Z: Annuler         }
            {- Ctrl+Y: Rétablir        }

(*3* Auto-Enregistrement du fichier source avant son exécution *)
           
var i:byte;
begin
  for i:=1 to 255 Do 
    Writeln(i:3,' - Bienvenue dans le monde de TPW 1.5');
end.