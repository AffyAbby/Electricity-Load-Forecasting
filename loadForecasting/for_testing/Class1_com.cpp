#include "Class1_com.hpp"
#include <string>

const wchar_t * Class1::loadForecasting_help = L" Create load profile plot";
std::map<std::string, const wchar_t*> Class1::help_map = createHelpMap();
Class1::Class1()
{
  g_pModule->InitializeComponentInstanceEx(&m_hinst);
}
Class1::~Class1()
{
  if (m_hinst)
    g_pModule->TerminateInstance(&m_hinst);
}
HRESULT __stdcall Class1::get_help(/*[in]*/ BSTR bstrName, /*[out, retval*/ BSTR* pbstrText)
{
  int wslen = SysStringLen(bstrName);
  int len = ::WideCharToMultiByte(CP_ACP, 0, 
    reinterpret_cast<wchar_t*>(bstrName), wslen, nullptr, 0, nullptr, nullptr);
  std::string strName(len, '\0');
  len = ::WideCharToMultiByte(CP_ACP, 0 /* no flags */,
                             reinterpret_cast<wchar_t*>(bstrName), 
                             wslen /* not necessarily NULL-terminated */,
                             &strName[0], len,
                             nullptr, nullptr /* no default char */);
  const wchar_t* help = help_map[strName];
  if (help)
  {
    *pbstrText = SysAllocString(help);
  }
  else
  {
    *pbstrText = SysAllocString(L"");
  }
  return S_OK;
}
std::map<std::string, const wchar_t*> Class1::createHelpMap()
{
  std::map<std::string, const wchar_t*> helpMap;
  helpMap["loadForecasting"] = loadForecasting_help;
  return helpMap;
}

HRESULT __stdcall Class1::loadForecasting(/*[in]*/long nargout, /*[in,out]*/VARIANT* y, 
                                           /*[in]*/VARIANT date, /*[in]*/VARIANT 
                                           temperature, /*[in]*/VARIANT isHoliday) {
  return( CallComFcn( "loadForecasting", (int) nargout, 1, 3, y, &date, &temperature, 
                      &isHoliday ) );
}
