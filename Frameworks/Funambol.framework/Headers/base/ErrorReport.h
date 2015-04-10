#ifndef INCL_ERROR_REPORT
#define INCL_ERROR_REPORT

#include "base/fscapi.h"
#include "base/globalsdef.h"
#include "base/util/StringBuffer.h"

BEGIN_NAMESPACE

class ErrorReport {
    private:
    StringBuffer refrence;
    StringBuffer message;
    
    StringBuffer className;
    StringBuffer method;
    StringBuffer lineNumber;
    public:
    StringBuffer getRefrence();
    StringBuffer getMessage();
    
    StringBuffer getClassName();
    StringBuffer getMethod();
    StringBuffer getLineNumber();
    
    void setRefrence(StringBuffer ref);
    void setMessage(StringBuffer msg);
    
    void setClassName(StringBuffer cls);
    void setMethod(StringBuffer mth);
    void setLineNumber(StringBuffer lno);
    
    
    static ErrorReport getLastErrorReport();
    static void setLastErrorReport(ErrorReport report);
    ErrorReport &operator = (ErrorReport report);
};


END_NAMESPACE

#endif