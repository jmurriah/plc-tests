@echo off 
chdir /d %~dp0
cd "..\..\DevProjects\BatchCompile"
"C:\Program Files\Python39\python.exe" BatchCompile.py
pause