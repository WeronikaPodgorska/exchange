Feature: Testing Excange Rates API


Scenario: Get default exchange rates
	Given I'm an ExhangeRates client
	When I make a GET request to LatestRates with the following data: api key = e23b955b797d5ac90bbff4c636cfaac1 and base =  and symbols = 
	Then the response status code is 200
    And the response should contain following data: success = true and base rate = EUR and other rates = AED,AFN,ALL,AMD,ANG,AOA,ARS,AUD,AWG,AZN,BAM,BBD,BDT,BGN,BHD,BIF,BMD,BND,BOB,BRL,BSD,BTC,BTN,BWP,BYN,BYR,BZD,CAD,CDF,CHF,CLF,CLP,CNY,COP,CRC,CUC,CUP,CVE,CZK,DJF,DKK,DOP,DZD,EGP,ERN,ETB,EUR,FJD,FKP,GBP,GEL,GGP,GHS,GIP,GMD,GNF,GTQ,GYD,HKD,HNL,HRK,HTG,HUF,IDR,ILS,IMP,INR,IQD,IRR,ISK,JEP,JMD,JOD,JPY,KES,KGS,KHR,KMF,KPW,KRW,KWD,KYD,KZT,LAK,LBP,LKR,LRD,LSL,LTL,LVL,LYD,MAD,MDL,MGA,MKD,MMK,MNT,MOP,MRO,MUR,MVR,MWK,MXN,MYR,MZN,NAD,NGN,NIO,NOK,NPR,NZD,OMR,PAB,PEN,PGK,PHP,PKR,PLN,PYG,QAR,RON,RSD,RUB,RWF,SAR,SBD,SCR,SDG,SEK,SGD,SHP,SLL,SOS,SRD,STD,SVC,SYP,SZL,THB,TJS,TMT,TND,TOP,TRY,TTD,TWD,TZS,UAH,UGX,USD,UYU,UZS,VEF,VND,VUV,WST,XAF,XAG,XAU,XCD,XDR,XOF,XPF,YER,ZAR,ZMK,ZMW,ZWL and rates values count = 168 and date = current date

Scenario: Get exchange rates only GBP,PLN,JPY and EUR exchange rates for base rate EUR
	Given I'm an ExhangeRates client
	When I make a GET request to LatestRates with the following data: api key = e23b955b797d5ac90bbff4c636cfaac1 and base = EUR and symbols = <symbols>
	Then the response status code is 200
    And the response should contain following data: success = true and base rate = EUR and other rates = <symbols> and rates values count = <count> and date = current date

	Examples: 
	| symbols                                                                         | count |
	| GBP,PLN,JPY,EUR                                                                 | 4     |
	| PLN,EUR                                                                         | 2     |
	| ETB,EUR,FJD                                                                     | 3     |
	| EUR,KRW,KWD,KYD,KZT,LAK,LBP,LKR,LRD,LSL,LTL,LVL,LYD,MAD,MDL,MGA,MKD,MMK,MNT,MOP | 20    |

	Scenario: Try to connect with API without api key
	Given I'm an ExhangeRates client
	When I make a GET request to LatestRates with the following data: api key =  and base =  and symbols = 
	Then the response status code is 401

	Scenario: Get exchange rates for invalid symbol rates for default base rate
	Given I'm an ExhangeRates client
	When I make a GET request to LatestRates with the following data: api key = e23b955b797d5ac90bbff4c636cfaac1 and base =  and symbols = GPB
	Then the response error code is invalid_currency_codes

	Scenario: Get exchange rates for base PLN without needed subscription 
	Given I'm an ExhangeRates client
	When I make a GET request to LatestRates with the following data: api key = e23b955b797d5ac90bbff4c636cfaac1 and base = <base> and symbols = 
	Then the response error code is base_currency_access_restricted

	Examples: 
	| base |
	| PLN  |
	| USD  |
	| GBP  |
	| JPY  |
	| AED  |
	| ZAR  |

	Scenario: Get exchange rates for invalid base rate
	Given I'm an ExhangeRates client
	When I make a GET request to LatestRates with the following data: api key = e23b955b797d5ac90bbff4c636cfaac1 and base = YYY and symbols = 
	Then the response error code is invalid_base_currency

