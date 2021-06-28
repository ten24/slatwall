/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:
	Additional Resources & Links
	Documentation - https://github.com/google/google-authenticator/wiki/Key-Uri-Format
	Documentation - https://github.com/google/google-authenticator/wiki/Conflicting-Accounts
	Example - https://daplie.github.io/browser-authenticator/
	Algorithm - Github Repo - https://github.com/marcins/cf-google-authenticator
	Algorithm - http://junkheap.net/blog/2013/05/30/implementing-google-authenticator-support-in-coldfusion/
	Base32 Java Library - Google - https://google.github.io/guava/releases/20.0/api/docs/index.html?com/google/common/io/BaseEncoding.html
	Base32 Java Library - Apache Commons - https://commons.apache.org/proper/commons-codec/apidocs/index.html?org/apache/commons/codec/binary/Base32.html
*/

/*
The MIT License (MIT)

Copyright (c) 2013 Marcin Szczepanski

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
component output="false" {    

    /**
    * Verifies the submitted value from the user against the user secret, with optional grace for the last few
    * token values
    *
    * @param base32secret the Base32 encoded shared secret key
    * @param userValue the value that the user submitted
    * @param grace the amount of previous tokens to allow (1 means allow the current and last token value)
    * @return a boolean whether the token was valid or not
    */
    public boolean function verifyGoogleToken (required string base32Secret, required string userValue, numeric grace = 0)
    {
        for (var i = 0; i <= grace; i++)
        {
            var expectedToken = getGoogleToken(base32Secret, -i, getCurrentTime());
            if (expectedToken == userValue) {
                return true;
            }
        }
        return false;
    }

    /**
    * Gets the value of the token for a particular offset from the current time interval
    *
    * @param base32secret the Base32 encoded shared secret key
    * @param offset the number of intervals from the current one to use (defaults to the current time interval)
    * @return a string containing the token for the specified offset interval
    */
    public string function getGoogleToken (required string base32Secret, numeric offset = 0)
    {
        var intervals = JavaCast("long", Int((getCurrentTime() / 1000) / 30) + arguments.offset);
        return getOneTimeToken(arguments.base32Secret, intervals);
    }

    /**
    * Returns a URL that can be used in a QR code with the Google Authenticator app
    *
    * @param email the email address of the user account
    * @param key the Base32 encoded secret key to use in the code
    */
    public string function getOTPURL(required string email, required string key)
    {
        return 'otpauth://totp/#arguments.email#?secret=#arguments.key#';
    }

    /**
    * The core TOTP function that gets the current value of the token for a particular secret key and numeric counter
    *
    * @param base32secret the Base32 encoded secret key
    * @param counter the counter value to use
    * @return a string representing the current token value
    */
    public string function getOneTimeToken (required string base32Secret, required numeric counter)
    {
        var key = base32decode(arguments.base32Secret);
        var secretKeySpec = createObject("java", "javax.crypto.spec.SecretKeySpec" ).init(key, "HmacSHA1");
        var mac = createObject("java", "javax.crypto.Mac").getInstance(secretKeySpec.getAlgorithm());
        mac.init(secretKeySpec);
        var buffer = createObject("java", "java.nio.ByteBuffer").allocate(8);
        buffer.putLong(arguments.counter);
        var h = mac.doFinal(buffer.array());
        var t = h[20];
        if (t < 0) t += 256;
        var o = bitAnd(t, 15) + 1;

        t = h[o + 3];

        if (t < 0) t += 256;
        var num = t;
        t = h[o + 2];
        if (t < 0) t += 256;
        num = bitOr(num, bitSHLN(t, 8));

        t = h[o + 1];
        if (t < 0) t += 256;
        num = bitOr(num, bitSHLN(t, 16));

        t = h[o];
        if (t < 0) t += 256;
        num = bitOr(num, bitSHLN(t, 24));

        num = bitAnd(num, 2147483647) % 1000000;

        return numberFormat(num, "000000");
    }

    /**
    * Generates a Base32 encoded secret key for use with the token functions
    *
    * @param password a password to be used as the seed for the secret key
    * @param salt a Java byte[16] array containing a salt - if left blank a random salt will be generated (recommended)
    * @return the Base32 encoded secret key
    */
    public string function generateKey (required string password, array salt = [])
    {
        if (arrayLen(salt) == 0)
        {
            var secureRandom = createObject("java", "java.security.SecureRandom").init();
            var buffer = createObject("java", "java.nio.ByteBuffer").allocate(16);
            arguments.salt = buffer.array();
            secureRandom.nextBytes(arguments.salt);
        }
        else if(arrayLen(salt) != 16)
        {
            throw(message="Salt must be byte[16]", errorcode="GoogleAuthenticator.BadSalt");
        }

        var keyFactory = createObject("java", "javax.crypto.SecretKeyFactory").getInstance("PBKDF2WithHmacSHA1");
        var keySpec = createObject("java", "javax.crypto.spec.PBEKeySpec").init(arguments.password.toCharArray(), salt, 128, 80);
        var secretKey = keyFactory.generateSecret(keySpec);
        return Base32encode(secretKey.getEncoded());
    }

    /**
    * A native Base32 encoder (see RFC4648 http://tools.ietf.org/html/rfc4648)
    *
    * Might not be the most efficient implementation. There is a version available
    * via the Apache Commons Codec, however this was only added in v1.5 and CF10 includes v1.3.
    *
    * I didn't want to create a dependency on JavaLoader or similar just for one simple(ish) encoder.
    *
    * @param array of Java byte[] to be encoded
    * @return a Base32 encoded string
    *
    */
    public string function Base32encode (required any inputBytes)
    {
        var values = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
        if (arrayLen(inputBytes) == 0)
        {
            return "";
        }
        var bytes = 0;
        if (ArrayLen(inputBytes) % 5 != 0)
        {
            var paddedLength = ArrayLen(inputBytes) + (5 - (ArrayLen(inputBytes) % 5));
            var buffer = createObject("java", "java.nio.ByteBuffer").allocate(paddedLength);
            buffer.put(inputBytes, 0, ArrayLen(inputBytes));
            bytes = buffer.array();
        }
        else
        {
            bytes = inputBytes;
        }

        var encoded = "";
        for (var i = 1; i <= arrayLen(bytes); i += 5)
        {
            byte = bytes[i];
            if (byte < 0) byte += 256;
            byte = bitSHRN(byte, 3);
            byte = bitAnd(byte, 31);
            encoded &= Mid(values, byte + 1, 1);

            byte = bytes[i];
            if (byte < 0) byte += 256;
            byte = bitAnd(byte, 7);
            byte = bitSHLN(byte, 2);
            byte2 = bytes[i+1];
            if (byte2 < 0) byte2 += 256;
            byte2 = bitSHRN(byte2, 6);
            byte2 = bitAnd(byte2, 3);
            byte = bitOr(byte, byte2);
            encoded &= Mid(values, byte + 1, 1);

            byte = bytes[i+1];
            if (byte < 0) byte += 256;
            byte = bitAnd(byte, 62);
            byte = bitSHRN(byte, 1);
            encoded &= Mid(values, byte + 1, 1);

            byte = bytes[i+1];
            if (byte < 0) byte += 256;
            byte = bitAnd(byte, 1);
            byte = bitSHLN(byte, 4);
            byte2 = bytes[i+2];
            if (byte2 < 0) byte2 += 256;
            byte2 = bitSHRN(byte2, 4);
            byte = bitOr(byte, byte2);
            encoded &= Mid(values, byte + 1, 1);

            byte = bytes[i+2];
            if (byte < 0) byte += 256;
            byte = bitAnd(byte, 15);
            byte = bitSHLN(byte, 1);
            byte2 = bytes[i+3];
            if (byte2 < 0) byte2 += 256;
            byte2 = bitSHRN(byte2, 7);
            byte = bitOr(byte, byte2);
            encoded &= Mid(values, byte + 1, 1);

            byte = bytes[i+3];
            if (byte < 0) byte += 256;
            byte = bitSHRN(byte, 2);
            byte = bitAnd(byte, 31);
            encoded &= Mid(values, byte + 1, 1);

            byte = bytes[i+3];
            if (byte < 0) byte += 256;
            byte = bitAnd(byte, 3);
            byte = bitSHLN(byte, 3);
            byte2 = bytes[i+4];
            if (byte2 < 0) byte2 += 256;
            byte2 = bitSHRN(byte2, 5);
            byte = bitOr(byte, byte2);
            encoded &= Mid(values, byte + 1, 1);

            byte = bytes[i+4];
            if (byte < 0) byte += 256;
            byte = bitAnd(byte, 31);
            encoded &= Mid(values, byte + 1, 1);
        }

        encoded = Left(encoded, (arrayLen(inputBytes) / 5) * 8 + 1);
        if (len(encoded) % 8 != 0) {
            encoded &= repeatString("=", 8 - (len(encoded) % 8) );
        }
        return encoded;
    }

    /**
    * Convenience function for creating a Base32 encoding of a string
    */
    public string function Base32encodeString (required any string)
    {
        return base32encode(string.getBytes());
    }

    /* borrowed from org.apache.commons.codec.binary.Base32 */
    this.DECODE_TABLE = [
       //  0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
          -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, // 00-0f
          -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, // 10-1f
          -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 63, // 20-2f
          -1, -1, 26, 27, 28, 29, 30, 31, -1, -1, -1, -1, -1, -1, -1, -1, // 30-3f 2-7
          -1,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, // 40-4f A-N
          15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25                     // 50-5a O-Z
    ];

    /**
    * Decodes a Base32 encoded string
    * @param encoded the encoded string to decode
    * @return a byte[] array of decoded values
    */
    public any function base32decode (required string encoded)
    {
        var decoded = "";
        var byte = 0;
        var byte2 = 0;
        var byte3 = 0;
        var encodedBytes = javaCast("string", encoded).getBytes();
        var unpaddedLength = Len(replace(encoded, "=", "", "all"));
        var decodedBytes = createObject("java", "java.io.ByteArrayOutputStream").init();
        for (var i = 1; i <= arrayLen(encodedBytes); i += 8)
        {
            if (encodedBytes[i + 1] == 61) break;
            byte = bitSHLN(this.DECODE_TABLE[encodedBytes[i]], 3);
            byte2 = bitSHRN(this.DECODE_TABLE[encodedBytes[i + 1]], 2);
            decodedBytes.write(bitOr(byte, byte2));

            if (encodedBytes[i + 3] == 61) break;
            byte = bitSHLN(bitAnd(this.DECODE_TABLE[encodedBytes[i + 1]], 3), 6);
            byte2 = bitSHLN(this.DECODE_TABLE[encodedBytes[i + 2]], 1);
            byte3 = bitSHRN(this.DECODE_TABLE[encodedBytes[i + 3]], 4);
            decodedBytes.write(bitOr(bitOr(byte, byte2), byte3));

            if (encodedBytes[i + 4] == 61) break;
            byte = bitSHLN(bitAnd(this.DECODE_TABLE[encodedBytes[i + 3]], 15), 4);
            byte2 = bitSHRN(this.DECODE_TABLE[encodedBytes[i + 4]], 1);
            decodedBytes.write(bitOr(byte, byte2));

            if (encodedBytes[i + 5] == 61) break;
            byte = bitSHLN(bitAnd(this.DECODE_TABLE[encodedBytes[i + 4]], 1), 7);
            byte2 = bitSHLN(this.DECODE_TABLE[encodedBytes[i + 5]], 2);
            byte3 = bitSHRN(this.DECODE_TABLE[encodedBytes[i + 6]], 3);
            decodedBytes.write(bitOr(bitOr(byte, byte2), byte3));

            if (encodedBytes[i + 7] == 61) break;
            byte = bitSHLN(bitAnd(this.DECODE_TABLE[encodedBytes[i + 6]], 7), 5);
            byte2 = this.DECODE_TABLE[encodedBytes[i + 7]];
            decodedBytes.write(bitOr(byte, byte2));

        }

        return decodedBytes.toByteArray();
    }

    /**
    * Convenience function for decoding a Base32 string to a string
    */
    public string function Base32decodeString (required any string, string encoding = "utf-8")
    {
        return charsetEncode(base32decode(string), encoding);//createObject("java", "java.lang.String").init(base32decode(string));
    }

    private numeric function getCurrentTime()
    {
        return createObject("java", "java.lang.System").currentTimeMillis();
    }
}