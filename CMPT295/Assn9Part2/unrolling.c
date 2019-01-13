/*

Murtaza Mushtaq
301347189
mmushtaq@sfu.ca

File contains two functions.
First function is inner6x1unrolling
Second function is inner6x6unrolling

*/
#include <stdio.h>
#include <stdlib.h>


 void inner6x1unrolling(vec_ptr u, vec_ptr v, data_t *dest) 
 { 
 long i; 
 long length = vec_length(u); 
 data_t *udata = get_vec_start(u); 
 data_t *vdata = get_vec_start(v); 
 data_t sum = (data_t) 0; 
  
 for (i = 0; i < length; i+=6) {

	sum = sum + (udata[i]*vdata[i]) + (udata[i+1]*vdata[i+1]) + (udata[i+2]*vdata[i+2]) + (udata[i+3]*vdata[i+3]) 
	+ (udata[i+4]*vdata[i+4]) + (udata[i+5]*vdata[i+5]);  
 } 
 *dest = sum+v1+v2+v3+v4+v5+v6; 
 }

 void inner6x6unrolling(vec_ptr u, vec_ptr v, data_t *dest) 
 { 
 long i; 
 long length = vec_length(u); 
 data_t *udata = get_vec_start(u); 
 data_t *vdata = get_vec_start(v); 
 data_t sum = (data_t) 0; 

 data_t v1 = 0;
 data_t v2 = 0;
 data_t v3 = 0;
 data_t v4 = 0;
 data_t v5 = 0;
 data_t v6 = 0;
  
 for (i = 0; i < length; i+=6) {
 
	v1 += udata[i]*vdata[i];
	v2 += udata[i+1]*vdata[i+1];
 	v3 += udata[i+2]*vdata[i+2];
 	v4 += udata[i+3]*vdata[i+3];
 	v5 += udata[i+4]*vdata[i+4];
 	v6 += udata[i+5]*vdata[i+5];
 } 
 *dest = sum+v1+v2+v3+v4+v5+v6; 
 }
