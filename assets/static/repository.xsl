<?xml version="1.0"?>

<!--
 * mod_dav_svn xsl2html index transformation script
 * derived from the subversion distrib files
 *
 * @author glaszig at gmail dot com
 * @link github.com/glaszig
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html"/>
  <!-- DEFINE YOUR SVN WEB ROOT BELOW -->
  <xsl:variable name="svnroot" select="'/svn'" />

  <xsl:template match="*"/>
  <xsl:template match="svn">
    <html>
      <head>
        <title>
          <xsl:value-of select="index/@base" />
          <xsl:if test="string-length(index/@name) != 0">
            <xsl:value-of select="index/@name"/>
            <xsl:text>: </xsl:text>
          </xsl:if>
          <xsl:value-of select="index/@path"/>
        </title>
        <link rel="stylesheet" type="text/css" href="/static/bootstrap.min.css"/>
        <style>
          html, body, td {
            font-size: 14px;
          }
          h1 {
            font-size: 21px;
            color: #aaa;
          }
          .breadcrumb {
            background-color: #fff;
            padding-left: 0;
          }
          .breadcrumb a {
            color: rgba(0,0,0,0.85);
          }
          .svn-icons {
            width: 24px;
            height: 24px;
          }
          td.icon {
            width: 26px;
          }
          .footer {
            margin-top: 50px;
            color: #aaa;
          }
        </style>
      </head>
      <body>
          <div class="container-fluid">
  		      <div>
  	   	       <xsl:apply-templates/>
  		      </div>
  		      <div class="footer row">
              <div class="col-md-12">
                <xsl:text>Powered by </xsl:text>
                <xsl:element name="a">
                  <xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
                  <xsl:text>Subversion</xsl:text>
                </xsl:element>
                <xsl:text> </xsl:text>
                <xsl:value-of select="@version"/>
                <xsl:text>, </xsl:text>
                <a href="http://www.rightstack.net" target="_blank">RightStack</a>
              </div>
            </div>
          </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="index">
    <h1>
      <span class="descr">Repository Files</span>
      <xsl:value-of select="@name"/>
    </h1>
    <ol class="breadcrumb">
      <xsl:if test="@base">
        <xsl:call-template name="insertAnchor">
          <xsl:with-param name="url" select="concat($svnroot, '/')"/>
          <xsl:with-param name="title" select="'/'"/>
        </xsl:call-template>
        <xsl:call-template name="SplitText">
          <xsl:with-param name="inputString" select="substring(concat(@base, @path), 1)"/>
          <xsl:with-param name="lastPart" select="substring($svnroot, 2)"/>
        </xsl:call-template>
      </xsl:if>
    </ol>

  	<table class="table table-hover">
      <xsl:apply-templates select="dir"/>
      <xsl:apply-templates select="file"/>
    </table>
  </xsl:template>

  <xsl:template match="dir">
    <tr class="dir">
      <td class="icon">
        <img class="svn-icons" src="/static/ic_folder_black_24dp_2x.png"/>
      </td>
      <td>
        <xsl:element name="a">
          <xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
	        <xsl:value-of select="@name"/>
	        <xsl:text>/</xsl:text>
        </xsl:element>
      </td>
	   </tr>
   </xsl:template>

   <xsl:template match="file">
     <tr class="file">
       <td class="icon"></td>
       <td>
         <xsl:element name="a">
           <xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
           <xsl:value-of select="@name"/>
         </xsl:element>
       </td>
     </tr>
   </xsl:template>

	<xsl:template name="SplitText">
		<xsl:param name="inputString"/>
		<xsl:param name="lastPart" />

    <li>
  		<xsl:choose>
  			<xsl:when test="substring-after($inputString,'/') != ''">
  				<xsl:call-template name="insertAnchor">
  					<xsl:with-param name="url" select="concat('/', $lastPart, '/', substring-before($inputString,'/'))"/>
  					<xsl:with-param name="title" select="concat(substring-before($inputString,'/'), '')"/>
  				</xsl:call-template>

  				<!-- recursion -->
  				<xsl:call-template name="SplitText">
  					<xsl:with-param name="inputString" select="substring-after($inputString,'/')"/>
  					<xsl:with-param name="lastPart" select="concat($lastPart, '/',  substring-before($inputString,'/'))" />
  				</xsl:call-template>
  			</xsl:when>
  			<xsl:otherwise>
  				<xsl:choose>
  					<xsl:when test="$inputString = ''">
  						<xsl:text></xsl:text>
  					</xsl:when>
  					<xsl:otherwise>
  						<!-- last recursion -->
  						<span class="pseudo">
  							<xsl:value-of select="translate($inputString, '/', '')"/>
  							<sup class="rev">
  								<xsl:text> r</xsl:text>
  								<xsl:value-of select="@rev"/>
  							</sup>
  						</span>
  					</xsl:otherwise>
  				</xsl:choose>
  			</xsl:otherwise>
  		</xsl:choose>
    </li>

	</xsl:template>

	<!-- template for inserting an html a element -->
	<xsl:template name="insertAnchor">
		<xsl:param name="url" />
		<xsl:param name="title" />

		<xsl:element name="a">
			<!-- href attribute -->
			<xsl:attribute name="href">
				<xsl:value-of select="$url"/>
			</xsl:attribute>
			<xsl:value-of select="$title"/>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
