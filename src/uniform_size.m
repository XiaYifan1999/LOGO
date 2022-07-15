function [Iusl,Iusr] = uniform_size(Il,Ir)
if size(Il,3)==1
    Il = repmat(Il,[1,1,3]);
end
if size(Ir,3)==1
    Ir = repmat(Ir,[1,1,3]);
end
[wl,hl,~] = size(Il);
[wr,hr,~] = size(Ir);
maxw = max(wl,wr); maxh = max(hl,hr);
Il(wl+1:maxw,hl+1:maxh,:) = 0;
Ir(wr+1:maxw,hr+1:maxh,:) = 0;
Iusl = Il; Iusr = Ir;
end