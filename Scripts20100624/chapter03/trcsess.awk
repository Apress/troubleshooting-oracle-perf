BEGIN { 
   FS = "="
}
/^APPNAME/ {
   module = substr($2,2,index($2,"' mh")-2)
   action = substr($4,2,index($4,"' ah")-2)
   if (action) printf "*** ACTION NAME:(%s) 0\n", action
   if (module) printf "*** MODULE NAME:(%s) 0\n", module
}
!/^APPNAME/ {
  print $0
}
