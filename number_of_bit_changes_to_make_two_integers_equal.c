#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>
static inline int my_clz(uint32_t x) {
    int count = 0;
    for (int i = 31; i >= 0; --i) {
        if (x & (1U << i))
            break;
        count++;
    }
    return count;
}
int bitChanges(int n, int k) {
    int num = n ^ k;
    num = my_clz(num);
    int result = 0;
    for(int i = 0;i < 32 - num;i++){
        if((n & 1) == 1 && (k & 1) == 0){
            result = result + 1;
        }
        else if((n & 1) == 0 && (k & 1) == 1){
            result = -1;
            break;
        }
        n >>= 1;
        k >>= 1;
    }
    return result;
}
int main(){
    int n1 = 13, k1 = 4;
    int n2 = 21, k2 = 21;
    int n3 = 14, k3 = 13;
    
    int result1 = bitChanges(n1, k1);
    int result2 = bitChanges(n2, k2);
    int result3 = bitChanges(n3, k3);
    
    printf("%d\n",result1);
    printf("%d\n",result2);
    printf("%d\n",result3);
    
    return 0;
}
