# IF
This is Object of "IF"

```objc
        int a = -3;
        [[IF Condition:((a>=0) ? OK.new : nil)
                Action:[Do b:^{NSLog(@"a=>0");
            return OK.new;}]
                  Else:[IF Condition:((a<0) ? OK.new : nil)
                              Action:[Do b:^{NSLog(@"a<0");
                      return OK.new;}]
                                Else:NG.new]
          ] do];
        
        IF *iff = [IF Condition:((a>=0) ? OK.new : nil)
                         Action:[Do b:^{NSLog(@"a=>0");return OK.new;}]
                           Else:[IF Condition:((a<0) ? OK.new : nil)
                                       Action:[Do b:^{NSLog(@"a<0");return OK.new;}]
                                         Else:NG.new]
                   ];
        DoBlock doblock = iff.getDoBlock;
        
        doblock();
```
