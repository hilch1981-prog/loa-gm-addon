local count=0
for _,path in ipairs(arg) do
  local fn,error=loadfile(path)
  assert(fn,error)
  count=count+1
end
print("PASS: Lua5.1 syntax files="..count)
