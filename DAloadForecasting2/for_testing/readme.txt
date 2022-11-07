DAloadForecasting MATLAB Excel Add-in 

1. Prerequisites for Deployment 

Verify that version 9.10 (R2021a) of the MATLAB Runtime is installed.   
If not, you can run the MATLAB Runtime installer.
To find its location, enter
  
    >>mcrinstaller
      
at the MATLAB prompt.
NOTE: You will need administrator rights to run the MATLAB Runtime installer. 

Alternatively, download and install the Windows version of the MATLAB Runtime for R2021a 
from the following link on the MathWorks website:

    https://www.mathworks.com/products/compiler/mcr/index.html
   
For more information about the MATLAB Runtime and the MATLAB Runtime installer, see 
"Distribute Applications" in the MATLAB Compiler documentation  
in the MathWorks Documentation Center.

2. Files to Deploy and Package

-DAloadForecasting_1_0.dll (output from mcc)
-DAloadForecasting.bas (VBA module file created by mcc)
-DAloadForecasting.xla (Excel AddIn file created by mcc)
-MCRInstaller.exe
    Note: if end users are unable to download the MATLAB Runtime using the
    instructions in the previous section, include it when building your 
    component by clicking the "Runtime included in package" link in the
    Deployment Tool.
-This readme file

NOTE: Verify that DAloadForecasting_1_0.dll is registered on the target machine. If you 
      have trouble registering this DLL, see Troubleshooting in the MATLAB Excel Add-in 
      documentation in the MathWorks Documentation Center.

3. Definitions

For information on deployment terminology, go to
https://www.mathworks.com/help and select MATLAB Compiler >
Getting Started > About Application Deployment >
Deployment Product Terms in the MathWorks Documentation
Center.
