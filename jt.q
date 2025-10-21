jt:.[!] flip(
  (`first; "Jacques");
  (`family; "Tati");
  (`dob; 1907.10.09);
  (`dod; 1982.11.05);
  (`spouse; "Micheline Winter");
  (`children; 3);
  (`pic; "https://en.wikipedia.org/wiki/Jacques_Tati#/media/File:Jacques_Tati.jpg") )

portrait:{
  n:" "sv x`first`family;                         / name
  i:.h.htac[`img;`alt`href!(n;x`pic);""];         / img
  a:"age ",string .[-;jt`dod`dob]div 365;         / age
  c:", "sv(n;"d. ",4#string x`dod;a);             / caption
  i,"<br>",.h.htac[`p;.[!]enlist each(`style;"font-style:italic");c] }