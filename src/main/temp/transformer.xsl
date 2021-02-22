<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="/">
        <html>
            <body>
                <h2>My Students</h2>
                <table border="1">
                    <tr bgcolor="#9acd32">
                        <th>First Name</th>
                        <th>Last Name</th>
                    </tr>
                    <xsl:for-each select="course/student">
                        <tr>
                            <td><xsl:value-of select="first_name"/></td>
                            <td><xsl:value-of select="last_name"/></td>
                        </tr>
                    </xsl:for-each>
                </table>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>