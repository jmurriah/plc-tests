@echo off 
chdir /d %~dp0
cd "..\..\DevProjects\JsonOpcUaCkeck"
"C:\Program Files\Python39\python.exe" JsonOpcUaCheck.py
pause