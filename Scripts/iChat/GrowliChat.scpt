FasdUAS 1.101.10   ��   ��    k             l      �� ��   82
* This script requires Growl. You can download Growl here: http://growl.info
* Once you have installed Growl, you can save this script as an application,
* remember to check the "Stays Open" option before saving.
* Then double-click the new application and enjoy.
*
* Comments and ideas to arminb@mac.com
       	  l     ������  ��   	  
  
 j     �� �� 0 idletime idleTime  m     ����       j    �� �� 0 lastlist lastList  J    ����        l     ������  ��        i    
    I     ������
�� .aevtoappnull  �   � ****��  ��    k     2       Z     +  ����  n        I    ��������  0 isichatrunning isIChatRunning��  ��     f       O    '    k    &      !   I   ������
�� .miscactvnull��� ��� null��  ��   !  "�� " r    & # $ # 6    % & % n     ' ( ' 1    ��
�� 
ID   ( 2    ��
�� 
pres & =    ) * ) 1    ��
�� 
stat * m    ��
�� pstaaval $ o      ���� 0 lastlist lastList��    m    	 + +�null     ߀��  d	iChat.app��� ���i��ш   }��� ���� 8   )       �"(�Й̿��Pnfez!  alis    H  Macintosh HD               �N�.H+    d	iChat.app                                                       aཥ7n        ����  	                Applications    �N�      ��N      d  #Macintosh HD:Applications:iChat.app    	 i C h a t . a p p    M a c i n t o s h   H D  Applications/iChat.app  / ��  ��  ��     ,�� , L   , 2 - - o   , 1���� 0 idletime idleTime��     . / . l     ������  ��   /  0 1 0 i     2 3 2 I     ������
�� .miscidlenmbr    ��� null��  ��   3 k     � 4 4  5 6 5 Z      7 8���� 7 n     9 : 9 I    ��������  0 isichatrunning isIChatRunning��  ��   :  f      8 k    { ; ;  < = < O     > ? > r     @ A @ 6   B C B n     D E D 1    ��
�� 
ID   E 2    ��
�� 
pres C =    F G F 1    ��
�� 
stat G m    ��
�� pstaaval A o      ���� 0 currentlist currentList ? m    	 + =  H I H l   ������  ��   I  J K J X    H L�� M L Z   . C N O���� N H   . 6 P P E  . 5 Q R Q o   . 3���� 0 lastlist lastList R o   3 4���� 0 x   O n  9 ? S T S I   : ?�� U���� *0 notifywithaccountid notifyWithAccountID U  V�� V o   : ;���� 0 x  ��  ��   T  f   9 :��  ��  �� 0 x   M o   ! "���� 0 currentlist currentList K  W X W l  I I������  ��   X  Y Z Y X   I s [�� \ [ Z   ] n ] ^���� ] H   ] a _ _ E  ] ` ` a ` o   ] ^���� 0 currentlist currentList a o   ^ _���� 0 x   ^ n  d j b c b I   e j�� d���� *0 notifywithaccountid notifyWithAccountID d  e�� e o   e f���� 0 x  ��  ��   c  f   d e��  ��  �� 0 x   \ o   L Q���� 0 lastlist lastList Z  f g f l  t t������  ��   g  h�� h r   t { i j i o   t u���� 0 currentlist currentList j o      ���� 0 lastlist lastList��  ��  ��   6  k�� k L   � � l l o   � ����� 0 idletime idleTime��   1  m n m l     ������  ��   n  o p o i     q r q I      �� s���� *0 notifywithaccountid notifyWithAccountID s  t�� t o      ���� 0 theid theID��  ��   r k     � u u  v w v r      x y x m      z z  
GrowliChat    y o      ���� 0 appname appName w  { | { r     } ~ } m        iChat Status    ~ o      ���� $0 notificationname notificationName |  � � � r     � � � J     � �  ��� � o    	���� $0 notificationname notificationName��   � o      ���� 
0 notifs   �  ��� � O    � � � � Z    � � ����� � l   # ��� � I   #�� ���
�� .coredoexbool       obj  � l    ��� � 6   � � � 4   �� �
�� 
pres � m    ����  � =    � � � 1    ��
�� 
ID   � o    ���� 0 theid theID��  ��  ��   � k   & � � �  � � � r   & 7 � � � n   & 5 � � � 1   3 5��
�� 
pnam � l  & 3 ��� � 6 & 3 � � � 4  & *�� �
�� 
pres � m   ( )����  � =  + 2 � � � 1   , .��
�� 
ID   � o   / 1���� 0 theid theID��   � o      ���� 0 thename theName �  � � � r   8 N � � � n  8 L � � � I   9 L�� ����� "0 stringforstatus stringForStatus �  ��� � n   9 H � � � 1   F H��
�� 
stat � l  9 F ��� � 6 9 F � � � 4  9 =�� �
�� 
pres � m   ; <����  � =  > E � � � 1   ? A��
�� 
ID   � o   B D���� 0 theid theID��  ��  ��   �  f   8 9 � o      ���� 0 	thestatus 	theStatus �  � � � r   O U � � � n   O S � � � 4  P S�� �
�� 
cwor � m   Q R����  � o   O P���� 0 theid theID � o      ���� 0 
theservice 
theService �  � � � O   V � � � � k   Z � � �  � � � I  Z k���� �
�� .registernull��� ��� null��   � �� � �
�� 
appl � o   \ ]���� 0 appname appName � �� � �
�� 
anot � o   ^ _���� 
0 notifs   � �� � �
�� 
dnot � o   ` a���� 
0 notifs   � �� ���
�� 
iapp � m   b e � �  iChat   ��   �  �� � I  l ��~�} �
�~ .notifygrnull��� ��� null�}   � �| � �
�| 
name � o   p q�{�{ $0 notificationname notificationName � �z � �
�z 
titl � o   t u�y�y 0 thename theName � �x � �
�x 
appl � o   v w�w�w 0 appname appName � �v ��u
�v 
desc � b   z � � � � b   z � � � � b   z  � � � o   z {�t�t 0 	thestatus 	theStatus � m   { ~ � �   (    � o    ��s�s 0 
theservice 
theService � m   � � � �  )   �u  �   � m   V W � �Znull     ߀�� #^GrowlHelperApp.app�ш   }���п�ր @   )       �"(�Й̿�� nGRRR   alis    �  Macintosh HD               �N�.H+   #^GrowlHelperApp.app                                              #m��4�        ����  	                	Resources     �N�      ��&�     #^ #Z #Y W T� T�  \�  fMacintosh HD:Users:ingmar:Library:PreferencePanes:Growl.prefPane:Contents:Resources:GrowlHelperApp.app  &  G r o w l H e l p e r A p p . a p p    M a c i n t o s h   H D  YUsers/ingmar/Library/PreferencePanes/Growl.prefPane/Contents/Resources/GrowlHelperApp.app   /    ��   �  ��r � l  � ��q�p�q  �p  �r  ��  ��   � m     +��   p  � � � l     �o�n�o  �n   �  � � � i     � � � I      �m ��l�m "0 stringforstatus stringForStatus �  ��k � o      �j�j 0 s  �k  �l   � Q     = � � � � w    3 � + � Z    3 � � � � � =    � � � o    �i�i 0 s   � m    �h
�h pstaaway � L     � � m     � �  	went away    �  � � � =    � � � o    �g�g 0 s   � m    �f
�f pstaoffl �  � � � L     � � m     � �  went offline    �  � � � =    � � � o    �e�e 0 s   � m    �d
�d pstaaval �  � � � L   ! # � � m   ! " � �  	came back    �  � � � =  & )   o   & '�c�c 0 s   m   ' (�b
�b pstaidle � �a L   , . m   , -  	is idling   �a   � L   1 3 m   1 2  status is unknown    � R      �`�_�^
�` .ascrerr ****      � ****�_  �^   � L   ; = m   ; <       � 	
	 l     �]�\�]  �\  
 �[ i     I      �Z�Y�X�Z  0 isichatrunning isIChatRunning�Y  �X   O      L     I   �W�V
�W .coredoexbool       obj  4    �U
�U 
prcs m      iChat   �V   m     �null     ߀��  "System Events.app��ш   }���0���� (   )       �"(�Й̿��`nsevs   alis    �  Macintosh HD               �N�.H+    "System Events.app                                                \e�n�
        ����  	                CoreServices    �N�      �n��      "      :Macintosh HD:System:Library:CoreServices:System Events.app  $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��  �[       	�T�S�T   �R�Q�P�O�N�M�L�R 0 idletime idleTime�Q 0 lastlist lastList
�P .aevtoappnull  �   � ****
�O .miscidlenmbr    ��� null�N *0 notifywithaccountid notifyWithAccountID�M "0 stringforstatus stringForStatus�L  0 isichatrunning isIChatRunning�S  �K�J�K  �J   �I �H�G�F
�I .aevtoappnull  �   � ****�H  �G     �E +�D�C�B�A�@�E  0 isichatrunning isIChatRunning
�D .miscactvnull��� ��� null
�C 
pres
�B 
ID    
�A 
stat
�@ pstaaval�F 3)j+   $� *j O*�-�,�[�,\Z�81Ec  UY hOb    �? 3�>�= �<
�? .miscidlenmbr    ��� null�>  �=   �;�:�; 0 currentlist currentList�: 0 x    �9 +�8�7�6�5�4�3�2�1�9  0 isichatrunning isIChatRunning
�8 
pres
�7 
ID  
�6 
stat
�5 pstaaval
�4 
kocl
�3 
cobj
�2 .corecnte****       ****�1 *0 notifywithaccountid notifyWithAccountID�< �)j+   x� *�-�,�[�,\Z�81E�UO )�[��l 	kh b  � )�k+ 
Y h[OY��O )b  [��l 	kh �� )�k+ 
Y h[OY��O�Ec  Y hOb    �0 r�/�.!"�-�0 *0 notifywithaccountid notifyWithAccountID�/ �,#�, #  �+�+ 0 theid theID�.  ! �*�)�(�'�&�%�$�* 0 theid theID�) 0 appname appName�( $0 notificationname notificationName�' 
0 notifs  �& 0 thename theName�% 0 	thestatus 	theStatus�$ 0 
theservice 
theService"  z  +�#�"�!� ��� ����� ������ � ��
�# 
pres
�" 
ID  
�! .coredoexbool       obj 
�  
pnam
� 
stat� "0 stringforstatus stringForStatus
� 
cwor
� 
appl
� 
anot
� 
dnot
� 
iapp� 
� .registernull��� ��� null
� 
name
� 
titl
� 
desc
� .notifygrnull��� ��� null�- ��E�O�E�O�kvE�O� �*�k/�[�,\Z�81j  m*�k/�[�,\Z�81�,E�O)*�k/�[�,\Z�81�,k+ 	E�O��k/E�O� 3*�����a a  O*a �a ��a �a %�%a %a  UOPY hU � ���$%�� "0 stringforstatus stringForStatus� �&� &  �� 0 s  �  $ �� 0 s  %  +� ��
 ��	 ����
� pstaaway
�
 pstaoffl
�	 pstaaval
� pstaidle�  �  � > 5�Z��  �Y %��  �Y ��  �Y ��  �Y �W 	X 
 � ���'(��  0 isichatrunning isIChatRunning�  �  '  ( �� 
� 
prcs
�  .coredoexbool       obj � � *��/j U ascr  ��ޭ