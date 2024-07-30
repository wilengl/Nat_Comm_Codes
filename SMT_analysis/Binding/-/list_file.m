function k = list_file(path, str)

a = dir(path);
k = 0;

for i = 1:length(a)  
   b = a(i).name;
   if contains(b, str)
       k = k+1;
   end
end