function uk = PIDE1(ek)
persistent uk_1 ek_1

if isempty(uk_1)
    uk_1 = 0;
    ek_1 = 0;
end
uk = uk_1 + 1.617*ek - 1.545*ek_1;
uk_1 = uk;
ek_1 = ek;
end