/*
* Access and use of this software shall impose the following
* obligations and understandings on the user. The user is granted the
* right, without any fee or cost, to use, copy, modify, alter, enhance
* and distribute this software, and any derivative works thereof, and
* its supporting documentation for any purpose whatsoever, provided
* that this entire notice appears in all copies of the software,
* derivative works and supporting documentation. Further, the user
* agrees to credit NOAA/NGDC in any publications that result from
* the use of this software or in any product that includes this
* software. The names NOAA/NGDC, however, may not be used
* in any advertising or publicity to endorse or promote any products
* or commercial entity unless specific written permission is obtained
* from NOAA/NGDC. The user also understands that NOAA/NGDC
* is not obligated to provide the user with any support, consulting,
* training or assistance of any kind with regard to the use, operation
* and performance of this software nor to provide the user with any
* updates, revisions, new versions or "bug fixes".
*
* THIS SOFTWARE IS PROVIDED BY NOAA/NGDC "AS IS" AND ANY EXPRESS
* OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
* ARE DISCLAIMED. IN NO EVENT SHALL NOAA/NGDC BE LIABLE FOR ANY SPECIAL,
* INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER
* RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF
* CONTRACT, NEGLIGENCE OR OTHER TORTUOUS ACTION, ARISING OUT OF OR IN
* CONNECTION WITH THE ACCESS, USE OR PERFORMANCE OF THIS SOFTWARE. 
 */
package thredds.server.metadata.nciso.util;

import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.ListIterator;

import org.jdom2.Attribute;
import org.jdom2.Content;
import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.JDOMException;
import org.jdom2.Namespace;
import org.jdom2.filter.Filters;
import org.jdom2.input.SAXBuilder;
import org.jdom2.output.Format;
import org.jdom2.output.XMLOutputter;
import org.jdom2.xpath.XPathExpression;
import org.jdom2.xpath.XPathFactory;

/**
 * XMLUtil
 * Date: Jun 5, 2010
 *
 * @author dneufeld
 */
public class XMLUtil {
  private static final org.slf4j.Logger _log = org.slf4j.LoggerFactory.getLogger(XMLUtil.class);

	private Document _doc = null;
		
   /** 
    * Class constructor.
    * 
    * @param fileName the name of the XML file to parse
    */	
	public XMLUtil(final String fileName) {
		SAXBuilder saxBuilder = new SAXBuilder();
        try {				    
		    _doc = saxBuilder.build(fileName);
        } catch (JDOMException jde) {
	        _log.error("JDOMException in XMLUtil: ", jde);	
        } catch (IOException ioe) {
        	_log.error("IOException in XMLUtil: ", ioe);		       
        }
	}
	
	/** 
	* Class constructor.
	* 
	* @param is an input stream of XML parse
	*/	
	public XMLUtil(InputStream is) {
		SAXBuilder saxBuilder = new SAXBuilder();
        try {				   
		    _doc = saxBuilder.build(is);
        } catch (JDOMException jde) {
        	_log.error("JDOMException in XMLUtil: ", jde);	
        } catch (IOException ioe) {
        	_log.error("IOException in XMLUtil: ", ioe);		       
        }
	}
	
	/** 
	* Returns a JDOM document.
	* 
	* @return document The JDOM document
	*/		
	public Document getDocument() {
		return _doc;
	}
	
	/** 
	* List elements in the XML document.
	* 
	* @param es list of XML elements
	* @param indent indentation string to use in printing out elements
	*/		
	public void listElements(final List<Element> es, final String indent) {
		for (Element e : es) {		    
		    listElement(e, indent);
		}
	}

	/** 
	* List elements by recursively traversing the XML document.
	*  
	* @param e an XML element
	* @param indent indentation string to use in printing out elements
	*/	
	public void listElement(final Element e, final String indent) {
	    _log.debug(indent + "*Element, name:" + 
		                     e.getName() + ", text:" + 
		                     e.getText().trim());

		//List all attributes
		List<Attribute> as = e.getAttributes();
		listAttributes(as, indent + " ");

		//List all children
		List<Element> c = e.getChildren();
		listElements(c, indent + " ");
	}

	/** 
	* List attributes from an element.
	*  
	* @param as an XML element's attributes
	* @param indent indentation string to use in printing out elements
	*/	
	public static void listAttributes(final List<Attribute> as, final String indent) {
		for (Attribute a : as) {
		    System.out.println(indent + "*Attribute, name:" + 
		                       a.getName() + ", value:" + 
		                       a.getValue());
		}
	}

	/** 
	* Find an XML element based on an XPath expression.
	*  
	* @param xPathExpr the XPath expression to locate an element
	* @param prefix the prefix used to denote the namespace 
	* @param nameSpace the namespace associated with the element being searched for
	* @return list list of found XML elements
	*/
	public List<Element> elemFinder(final String xPathExpr, final String prefix, final String nameSpace) {
		Namespace ns = Namespace.getNamespace(prefix, nameSpace);
		XPathExpression<Element> xpath =
				XPathFactory.instance().compile(xPathExpr, Filters.element(), null, ns);
		return xpath.evaluate(_doc);
  }
	
	/** 
	* Sort an XML document based on a comparator
	*  
	* @param parent the root XML element used for sorting
	* @param c the comparator used for sorting
	*/
	public void sortElements(Element parent, final Comparator<Element> c) {
	    // Create a new, static list of child elements, and sort it.
	    List<Element> children = parent.getChildren();
	    sort(children, c);
	    ListIterator<Element> childrenIter = children.listIterator();

	    // Create a new, static list of all content items.

	    List<Content> content = new ArrayList(parent.getContent());
	    ListIterator<Content> contentIter = content.listIterator();

	    // Loop through the content items, and whenever we find an Element,
	    // we'll insert the next ordered Element in its place. Because the
	    // content list is not live, it won't complain about an Element
	    // being added twice.
      while(contentIter.hasNext()) {
          Object obj = contentIter.next();
          if (obj instanceof Element) {
              Element origChildElement = childrenIter.next();
              Element cloneChildElement = origChildElement.clone();
              cloneChildElement.detach();
              contentIter.set(cloneChildElement);
          }
      }
      // Finally, we set the content list back into the parent Element.
      List<Element> emptyList = new ArrayList<>();
      parent.setContent(emptyList);
      parent.setContent(content);
	}
	
	private void sort(List<Element> list, Comparator<Element> c) {
		Element[] a = list.toArray(new Element[0]);
		Arrays.sort(a, c);

		for (Element element : a) {
			element.detach(); //removes Element also from "list"
		}

		Collections.addAll(list, a);

	}

	/** 
	* Write out the XML document.
	* 
N	*/
	public void write(final String fileName) {
	    try {
	        FileWriter writer = new FileWriter(fileName);
	        doWrite(writer);
	    } catch (java.io.IOException e) {
	        _log.error("IOException in XMLUtil: ", e);
	    }
	}
	
	/** 
	* Write out the XML document.
	* 
	* @param writer the writer to use for the XML output 
	*/	
	public void write(final Writer writer) {
		doWrite(writer);
	}
	
	private void doWrite(final Writer writer) {
	    try {
	        XMLOutputter outputter = new XMLOutputter();
	        Format newFormat = Format.getCompactFormat();
	        newFormat.setIndent("  ");
	        outputter.setFormat(newFormat);
	        outputter.output(_doc, writer);	

	    } catch (java.io.IOException e) {
	        _log.error("IOException in XMLUtil: ", e);
	    }		
	}
	
}
