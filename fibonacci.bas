dim fi[16]
fi[0] = 0
fi[1] = 1
for i = 2 to 15
	fi[i] = fi[i-1] + fi[i-2]
next
for i = 0 to 15
	print fi[i];", ";
next
print "..."

System("pause")

end
