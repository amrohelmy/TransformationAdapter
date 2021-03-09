<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:wd="urn:com.workday.report/INT001a_Workday_to_CDS_CR"
                exclude-result-prefixes="xs"
                version="2.0">

    <xsl:output method="text" byte-order-mark="no" encoding="UTF-8"></xsl:output>

    <xsl:template match="/">


        <xsl:variable name="linefeed" select="'&#xA;'"/>
        <xsl:variable name="Tab" select="'&#x9;'"/>
        <xsl:variable name="CZ" select="'CZ'"/>
        <xsl:variable name="GR" select="'GR'"/>
        <xsl:variable name="NL" select="'NL'"/>

        <!-- 2017.01.11 EMPL_Status removed and deparment (name) added -->
        <b><xsl:text>employeeNumber	cn	surname	givenName	preferredName	initials	gender	personalTitle	homePostalAddress	homePhone	normalizedSurname	employeeType	functionCode	title	employmentDate	terminationDate	hrContactPerson	manager	legalEntity	organizationCode	departmentCode	department	mobile	telephoneNumber	facsimileTelephoneNumber	groupTelephoneNumber	telephoneNumber2	roomNumber	registeredAddress	postalAddress	l	postalCode	street	mail	tenantCode	c	organizationalPointer	description	postalOfficeBox	preferredLanguage	prefIntPostalAddress	carLicense	billingCode	insertion	employeeID	managerCK</xsl:text></b>
        <xsl:value-of select="$linefeed"/>


        <xsl:variable name="Counter" select="0"/>
        <xsl:for-each select="wd:Report_Data/wd:Report_Entry/wd:All_Positions_Jobs">

            <!-- Start-->
            <!-- Updated employeeNumber to be selected between CDS IDs if available from wd:All_Positions_Jobs or Workday ID otherwise -->
            <!--employeeNumber -->
            <!-- This is the ID sent in the file as the worker's CDS id. The logic below will try to select first the worker's Previous Source ID for CDS (PSIforCDS) linked to this position.
                     If this is not present, it will send the worker's Workday ID.
                     -->

            <xsl:choose>
                <xsl:when test="wd:Previous_Source_CDS_ID_by_Position != ''">
                    <xsl:value-of select="normalize-space(wd:Previous_Source_CDS_ID_by_Position)"></xsl:value-of><xsl:value-of select="$Tab"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space(parent::node()/wd:WD_Employee_ID_padded)"></xsl:value-of><xsl:value-of select="$Tab"/>
                </xsl:otherwise>
            </xsl:choose>
            <!--cn--><xsl:value-of select="normalize-space(parent::node()/wd:Cn)"/><xsl:value-of select="$Tab"/>
            <!--surname--><xsl:value-of select="normalize-space(parent::node()/wd:Surname)"></xsl:value-of><xsl:value-of select="$Tab"/>
            <!--givenName--><xsl:value-of select="normalize-space(parent::node()/wd:Given_First_Name)"></xsl:value-of><xsl:value-of select="$Tab"/>
            <!--preferredName--><xsl:value-of select="normalize-space(parent::node()/wd:Preferred_First_Name)"></xsl:value-of><xsl:value-of select="$Tab"/>
            <!--initials--><xsl:value-of select="parent::node()/wd:Initials"></xsl:value-of><xsl:value-of select="$Tab"/>
            <!--gender-->
            <xsl:choose>
                <xsl:when test="parent::node()/wd:Gender='Male' or parent::node()/wd:Gender='Female'">
                    <xsl:value-of select="parent::node()/wd:Gender"></xsl:value-of><xsl:value-of select="$Tab"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$Tab"/>
                </xsl:otherwise>
            </xsl:choose>

            <!--personalTitle--><xsl:value-of select="parent::node()/wd:Salutation"></xsl:value-of><xsl:value-of select="$Tab"/>
            <!--homePostalAddress-->
            <!-- LOCALIZATION: Home Addresses for Belgium are not sent due to privacy/legal restrictions in that country. -->
            <xsl:choose>
                <xsl:when test="wd:Location_-_Address_Country != 'Belgium'">
                    <xsl:choose>
                        <xsl:when test="normalize-space(parent::node()/wd:Primary_Home_Address)='$$$'"><xsl:text></xsl:text></xsl:when>
                        <xsl:otherwise><xsl:value-of select="normalize-space(parent::node()/wd:Primary_Home_Address)"></xsl:value-of></xsl:otherwise>
                    </xsl:choose><xsl:value-of select="$Tab"/>
                </xsl:when>
                <xsl:otherwise><xsl:value-of select="$Tab"/></xsl:otherwise>
            </xsl:choose>

            <!--homePhone--><xsl:value-of select="translate(translate(parent::node()/wd:Phone_-_Primary_Home,'&#40;',''),'&#41;','')"></xsl:value-of><xsl:value-of select="$Tab"/>
            <!--normalizedSurname-->
            <!-- This field contains the current worker's surname in basic latin characters ("normalized").
                     The logic below will:
                        - Replace non-latin characters that normalize_unicode function does not decompose 
                            replace(replace(replace(replace(replace(parent::node()/wd:NormalizeSurname,'Œ','Oe'),'œ','oe'),'Æ','Ae'),'æ','ae'),'ß','ss')
                            translate(<previous_result_string>,'ĐđĦħıĸŁłŊŋŦŧÐØøÞðþ','DdHhikLlNnTtDOoBdb')
                        - Decompose all characters remaining in the surname into their character components using normalize-unicode function with NFKD parameter (Normalization Form Compatibility Decomposition). For Example, é is broken into e + the accent mark character.
                            normalize-unicode(<previous_result_string>,'NFKD')
                        - Replace all non BasicLatin characters (\P{IsBasicLatin} is the negation of the set {IsBasicLatin}) with an empty character ''.
                -->
            <xsl:value-of select="
                replace(
                normalize-unicode( 
                translate(
                replace(
                replace(
                replace(
                replace(
                replace(
                parent::node()/wd:NormalizeSurname
                ,'Œ','Oe')
                ,'œ','oe')
                ,'Æ','Ae')
                ,'æ','ae')
                ,'ß','ss')
                ,'ĐđĦħıĸŁłŊŋŦŧÐØøÞðþ','DdHhikLlNnTtDOoBdb')
                ,'NFKD')
                ,'\P{IsBasicLatin}', '')
                "/>
            <xsl:value-of select="$Tab"/>
            <!--employeeType--><xsl:value-of select="parent::node()/wd:Worker_Type"></xsl:value-of><xsl:value-of select="$Tab"/>
            <!--functionCode--><xsl:value-of select="wd:FunctionCode"></xsl:value-of><xsl:value-of select="$Tab"/>
            <!--title-->
            <xsl:choose>
                <!-- LOCALIZATION: Romania Insurance requested Position Title to be sent for this field -->
                <xsl:when test="wd:Location_-_Address_Country = 'Romania' and wd:Company_Hierarchy='NN Insurance Companies'">
                    <xsl:value-of select="wd:Position_Title"></xsl:value-of><xsl:value-of select="$Tab"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="wd:Business_Title"></xsl:value-of><xsl:value-of select="$Tab"/>
                </xsl:otherwise>
            </xsl:choose>
            <!--employmentDate-->
            <xsl:choose>
                <!-- LOCALIZATION: Belgium Insurance requested Seniority Date to be sent for this field -->
                <xsl:when test="wd:Location_-_Address_Country = 'Belgium' and wd:Company_Hierarchy='NN Insurance Companies'">
                    <xsl:value-of select="substring(parent::node()/wd:Seniority_Date,1,10)"></xsl:value-of><xsl:value-of select="$Tab"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring(parent::node()/wd:Original_Hire_Date,1,10)"></xsl:value-of><xsl:value-of select="$Tab"/>
                </xsl:otherwise>
            </xsl:choose>
            <!--terminationDate--><xsl:value-of select="$Tab"/>
            <!--hrContactPerson-->
            <xsl:choose>
                <!-- This field is the current worker's HR Partner (ID). 
                    First, try to send the Previous Source ID for CDS (PSIforCDS) linked to the HR Partner's Primary Position if not empty-->
                <xsl:when test="wd:HR_Partner_Primary_Position_CDS_ID != ''">
                    <xsl:value-of select="wd:HR_Partner_Primary_Position_CDS_ID"/><xsl:value-of select="$Tab"/>
                </xsl:when>
                <!-- If the above fails, try to send the element wd:HR_Partner which can be either:
                    - Any PSIforCDS that the HR Partner has (workers should only have one, but if several present, the report will select the first one by Custom ID Type name alphabetically ordered.
                    - The HR Partner's Workday ID if the HR Partner has no PSIforCDS ids -->
                <xsl:when test="wd:HR_Partner != ''">
                    <xsl:value-of select="wd:HR_Partner"/><xsl:value-of select="$Tab"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$Tab"/>
                </xsl:otherwise>
            </xsl:choose>
            <!--manager-->
            <xsl:choose>
                <!-- This field is the manager (id) for the current worker. This logic (first "when") attempts to extract the Manager's Previous Source ID for CDS (PSIforCDS)
                    for the current country and tenant code if the manager has a record in this same file (this would happen if the manager has a position in the
                    same country and tenant code as the worker).
                    Note that the Custom_ID_Type element under "wd:All_Worker_CDS_IDs" contains the reference ID of the PSIforCDS Custom ID Type, and this reference id contains
                    the country and tenant code it corresponds to (i.e. for Country "Netherlands" and Tenant Code "HQ" the PSIforCDS reference id is "PreviousSourceIDforCDS_NL_HQ").
                -->
                <xsl:when test="exists(../../wd:Report_Entry[substring(wd:WD_Employee_ID_padded,2) = current()/wd:Manager]/wd:All_Worker_CDS_IDs[substring(wd:Custom_ID_Type,24,2) = current()/wd:Country_Alpha_2_Code and substring(wd:Custom_ID_Type,27) = current()/wd:New_Tenant_Code]/wd:Custom_ID)">
                    <xsl:value-of select="../../wd:Report_Entry[substring(wd:WD_Employee_ID_padded,2) = current()/wd:Manager]/wd:All_Worker_CDS_IDs[substring(wd:Custom_ID_Type,24,2) = current()/wd:Country_Alpha_2_Code and substring(wd:Custom_ID_Type,27) = current()/wd:New_Tenant_Code]/wd:Custom_ID"/><xsl:value-of select="$Tab"/>
                </xsl:when>
                <!-- If the logic above can't find a matching PSIforCDS, the following "when" below will be evaluated. The PSIforCDS linked to the Manager's primary position will be used if this is not empty. -->
                <xsl:when test="wd:Manager_s_Primary_Position_CDS_ID != ''">
                    <xsl:value-of select="wd:Manager_s_Primary_Position_CDS_ID"/><xsl:value-of select="$Tab"/>
                </xsl:when>
                <!-- If none of the two IDs above can be found, the system will try to send the field wd:Manager (if not empty) which is the Manager's Workday ID (Employee ID or Contingent Worker ID)-->
                <xsl:when test="wd:Manager != ''">
                    <xsl:value-of select="concat('0',wd:Manager)"/><xsl:value-of select="$Tab"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$Tab"/>
                </xsl:otherwise>
            </xsl:choose>
            <!--legalEntity--><xsl:value-of select="wd:Company"></xsl:value-of><xsl:value-of select="$Tab"/>
            <!--organizationCode-->
            <xsl:choose>
                <!-- LOCALIZATION: Netherlands Superv. Orgs have specific Organization Code structure that other countries do not have. 
                     A section of this code is required to be sent to CDS for Netherlands in this field.
                     This is not required for the rest of the countries in this field. -->
                <xsl:when test="wd:Location_-_Address_Country = 'Netherlands'">
                    <xsl:value-of select="substring(wd:Code,3,3)"></xsl:value-of><xsl:value-of select="$Tab"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$Tab"/>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:variable name="OrgCode"><xsl:value-of select="substring(wd:Code,3,3)"></xsl:value-of></xsl:variable>
            <!--departmentCode-->
            <xsl:choose>
                <!-- LOCALIZATION: Netherlands and Belgium Insurance have each different logics for this field. wd:Code is extracted from the Supervisory Org code -->
                <xsl:when test="wd:Location_-_Address_Country = 'Netherlands'">
                    <xsl:value-of select="substring(wd:Code,6)"/><xsl:value-of select="$Tab"/>
                </xsl:when>
                <xsl:when test="wd:Company = '127700'">
                    <xsl:value-of select="wd:Org_Pointer_CDS"/><xsl:value-of select="$Tab"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="wd:Code"/><xsl:value-of select="$Tab"/>
                </xsl:otherwise>
            </xsl:choose>
            <!--department (name) --><xsl:value-of select="wd:Supervisory_Org_Name"/><xsl:value-of select="$Tab"/>
            <!--mobile--><xsl:value-of select="translate(translate(parent::node()/wd:Primary_Work_Mobile_Phone,'&#40;',''),'&#41;','')"/><xsl:value-of select="$Tab"/>
            <!--telephoneNumber-->
            <xsl:choose>
                <!-- LOCALIZATION: Belgium Insurance requested swaping telephoneNumber and telephoneNumber2 values in the file to CDS.-->
                <xsl:when test="wd:Location_-_Address_Country = 'Belgium' and wd:Company_Hierarchy='NN Insurance Companies'">
                    <xsl:value-of select="translate(translate(parent::node()/wd:TelephoneNumber2,'&#40;',''),'&#41;','')"></xsl:value-of><xsl:value-of select="$Tab"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="translate(translate(parent::node()/wd:Primary_Work_Phone,'&#40;',''),'&#41;','')"></xsl:value-of><xsl:value-of select="wd:Primary_Work_Phone"></xsl:value-of><xsl:value-of select="$Tab"/>
                </xsl:otherwise>
            </xsl:choose>
            <!--facsimileTelephoneNumber--><xsl:value-of select="wd:facsimileTelephoneNumber"></xsl:value-of><xsl:value-of select="$Tab"/>
            <!--groupTelephoneNumber--><xsl:value-of select="$Tab"/>
            <!--telephoneNumber2-->
            <xsl:choose>
                <!-- LOCALIZATION: Belgium Insurance requested swaping telephoneNumber and telephoneNumber2 values in the file to CDS.-->
                <xsl:when test="wd:Location_-_Address_Country = 'Belgium' and wd:Company_Hierarchy='NN Insurance Companies'">
                    <xsl:value-of select="translate(translate(parent::node()/wd:Primary_Work_Phone,'&#40;',''),'&#41;','')"></xsl:value-of><xsl:value-of select="wd:Primary_Work_Phone"></xsl:value-of><xsl:value-of select="$Tab"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="translate(translate(parent::node()/wd:TelephoneNumber2,'&#40;',''),'&#41;','')"></xsl:value-of><xsl:value-of select="$Tab"/>
                </xsl:otherwise>
            </xsl:choose>
            <!--roomNumber<xsl:value-of select="parent::node()/wd:roomNumber"></xsl:value-of><xsl:value-of select="$Tab"/>-->
            <!-- New Room Number --><xsl:value-of select="replace(substring-after(wd:Work_Space/@wd:Descriptor,' > '),' > ','.')"/><xsl:value-of select="$Tab"/>
            <!--registeredAddress--><xsl:value-of select="normalize-space(replace(translate(wd:Location_-_Full_Address_with_Country,'&amp;',''),'#xa;','\$'))"></xsl:value-of><xsl:value-of select="$Tab"/>
            <!--postalAddress--><xsl:value-of select="normalize-space(replace(translate(wd:Location_-_Full_Address_with_Country,'&amp;',''),'#xa;','\$'))"/><xsl:value-of select="$Tab"/>
            <!--l--><xsl:value-of select="wd:Location_Address_City"></xsl:value-of><xsl:value-of select="$Tab"/>
            <!--postalCode--><xsl:value-of select="wd:Location_Address_Postal_Code"></xsl:value-of><xsl:value-of select="$Tab"/>
            <!--street--><xsl:value-of select="$Tab"/>
            <!--mail-->
            <xsl:choose>
                <!-- LOCALIZATION: Belgium Insurance requested only the Belgian email to be sent in their file in this field. There is a Calculated field in the report in WD to extract this BE email. -->
                <xsl:when test="wd:Location_-_Address_Country = 'Belgium' and wd:Company_Hierarchy='NN Insurance Companies' and parent::node()/wd:BE_Work_Email != ''">
                    <xsl:value-of select="parent::node()/wd:BE_Work_Email"></xsl:value-of><xsl:value-of select="$Tab"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="parent::node()/wd:primaryWorkEmail"></xsl:value-of><xsl:value-of select="$Tab"/>
                </xsl:otherwise>
            </xsl:choose>
            <!-- New Tenant Code--><xsl:value-of select="wd:New_Tenant_Code"></xsl:value-of><xsl:value-of select="$Tab"/>
            <!--c--><xsl:value-of select="wd:Country_Alpha_2_Code"/><xsl:value-of select="$Tab"/>
            <!--organizationalPointer-->
            <!-- 20200706: Remove CDS ORG Pointer for BE-Insurance -->
            <xsl:choose>
                <xsl:when test="wd:Location_-_Address_Country = 'Belgium' and wd:Company_Hierarchy='NN Insurance Companies'">
                    <xsl:choose>
                        <!-- 20200706: Only Applicable for CEO Insurance International = Fixed code 'BIN01300000'-->
                        <xsl:when test="wd:Code='00350100080'">
                            <xsl:text>BIN01300000</xsl:text><xsl:value-of select="$Tab"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="wd:Code"/><xsl:value-of select="$Tab"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="wd:Org_Pointer_CDS"/><xsl:value-of select="$Tab"/>
                </xsl:otherwise>
            </xsl:choose>
            <!--description--><xsl:value-of select="$Tab"/>
            <!--postalOfficeBox--><xsl:value-of select="$Tab"/>
            <!--preferredLanguage-->
            <xsl:choose>
                <!-- LOCALIZATION: Belgium Insurance requested this field to be sent blank.-->
                <xsl:when test="wd:Location_-_Address_Country = 'Belgium' and wd:Company_Hierarchy='NN Insurance Companies'">
                    <xsl:value-of select="$Tab"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="parent::node()/wd:Preferred_Display_Language"></xsl:value-of><xsl:value-of select="$Tab"/>
                </xsl:otherwise>
            </xsl:choose>
            <!--prefIntPostalAddress--><xsl:value-of select="$Tab"/>
            <!--carLicense--><xsl:value-of select="$Tab"/>
            <!--billingCode--><xsl:value-of select="wd:billingCode"></xsl:value-of><xsl:value-of select="$Tab"/>
            <!--EMPL_STATUS (Removed 2017.01.11) <xsl:value-of select="parent::node()/wd:EMPL_STATUS"></xsl:value-of><xsl:value-of select="$Tab"/>-->
            <!--insertion--><xsl:value-of select="parent::node()/wd:insertion"></xsl:value-of><xsl:value-of select="$Tab"/>
            <!-- employeeID--><xsl:value-of select="parent::node()/wd:employeeID"></xsl:value-of><xsl:value-of select="$Tab"/>
            <!-- Manager CK--><xsl:value-of select="wd:Manager_CorporateKey/@wd:Descriptor"/><xsl:value-of select="$Tab"/>
            <xsl:value-of select="$linefeed"></xsl:value-of>
        </xsl:for-each>
        <b><xsl:text>***End of file***</xsl:text></b>
    </xsl:template>
</xsl:stylesheet>