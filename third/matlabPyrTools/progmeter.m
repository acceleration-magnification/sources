function progmeter(i,n,w)

if nargin<3, 
    w = 1;
end

if i==0    
    fwrite(1,sprintf('00%%'));
    return;
elseif ischar(i)
    fwrite(1,sprintf('%s\n',i));
    fwrite(1,sprintf('00%%'));
    return;
end

if mod(i,w*n/100) <= mod(i-1,w*n/100),
    fwrite(1,sprintf('\b\b\b'));
    fwrite(1,sprintf('%02d%%', round(100*i/n)));
end

if i==n,
  fprintf(1,'\n');
end
