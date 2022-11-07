Dim MCLUtil As Object
Dim bModuleInitialized As Boolean
Dim Class1 As Object 

Private Sub InitModule()
    If Not bModuleInitialized Then
        On Error GoTo Handle_Error
        If MCLUtil Is Nothing Then
            Set MCLUtil = CreateObject("MWComUtil.MWUtil9.10")
        End If
        Call MCLUtil.MWInitApplication(Application)
        
        bModuleInitialized = True
        Exit Sub
Handle_Error:
        bModuleInitialized = False
    End If
End Sub

Function loadForecasting(Optional date0 As Variant, Optional temperature As Variant,  _
    Optional isHoliday As Variant) As Variant

    Dim y As Variant

    On Error GoTo Handle_Error

    Call InitModule()

    If Class1 Is Nothing Then
        Set Class1 = CreateObject("loadForecasting.Class1.1_0")
    End If

    Call Class1.loadForecasting(1, y, date0, temperature, isHoliday)
    loadForecasting = y

    Exit Function
Handle_Error:
    loadForecasting = "Error in " & Err.Source & ": " & Err.Description
End Function

