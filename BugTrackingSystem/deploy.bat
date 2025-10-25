@echo off
REM -------------------------------
REM Deploy BugTrackingSystem to Tomcat
REM -------------------------------

echo Compiling Java files...

"C:\Program Files\Java\jdk-25\bin\javac.exe" -d WebContent/WEB-INF/classes -cp "WebContent/WEB-INF/lib/*;C:/apache-tomcat-9.0.111/lib/servlet-api.jar" ^
src\com\bugtracker\config\*.java ^
src\com\bugtracker\dao\*.java ^
src\com\bugtracker\filter\*.java ^
src\com\bugtracker\model\*.java ^
src\com\bugtracker\servlet\*.java

IF %ERRORLEVEL% NEQ 0 (
    echo Compilation failed! Check errors above.
    pause
    exit /b
)

echo Creating WAR file...

"C:\Program Files\Java\jdk-25\bin\jar.exe" -cvf BugTrackingSystem.war -C WebContent .

echo Deploying to Tomcat...

copy BugTrackingSystem.war C:\apache-tomcat-9.0.111\webapps\

echo Deployment complete!
pause


