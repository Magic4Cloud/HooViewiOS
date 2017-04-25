//
//  EVLoginInfo.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVLoginInfo.h"
#import "EVBaseToolManager.h"
#import "EVRelationWith3rdAccoutModel.h"
#import "NSString+Extension.h"
#import "EVStockBaseModel.h"

#define kLoginInfoPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"EVLoginInfo.arc"]

@implementation EVLoginIMInfo

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInt64:self.LastLoginTime forKey:@"LastLoginTime"];
    [encoder encodeObject:self.jid forKey:@"jid"];
    [encoder encodeObject:self.password forKey:@"password"];
    [encoder encodeObject:self.resource forKey:@"resource"];
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.username forKey:@"username"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    EVLoginIMInfo *info = [[EVLoginIMInfo alloc] init];
    info.LastLoginTime = [decoder decodeInt64ForKey:@"LastLoginTime"];
    info.jid = [decoder decodeObjectForKey:@"jid"];
    info.password = [decoder decodeObjectForKey:@"password"];
    info.resource = [decoder decodeObjectForKey:@"resource"];
    info.token = [decoder decodeObjectForKey:@"token"];
    info.username = [decoder decodeObjectForKey:@"username"];
    return info;
}

@end

@interface EVLoginInfo ()
//{
//    NSString *_phone;
//}

@end

@implementation EVLoginInfo


- (NSString *)phone
{
    NSString *phoneTemp = _phone;
    if ( phoneTemp.length > 0 )
    {
        return phoneTemp;
    }
    
    if ( self.auth.count > 0 )
    {
        for (EVRelationWith3rdAccoutModel *thirdAccount in self.auth)
        {
            if ( [thirdAccount.type isEqualToString:@"phone"] && thirdAccount.token && thirdAccount.token.length > 0 )
            {
                phoneTemp = [thirdAccount.token mutableCopy];
                NSRange range = [phoneTemp rangeOfString:@"_"];
                phoneTemp = [phoneTemp substringFromIndex:range.location + range.length];
            }
        }
    }
    
    return phoneTemp;
}

- (void)setImpwd:(NSString *)impwd
{
    if ( [impwd isKindOfClass:[NSString class]] )
    {
        _impwd = impwd;
    }
}

- (void)setImuser:(NSString *)imuser
{
    if ( [imuser isKindOfClass:[NSString class]] )
    {
        _imuser = imuser;
//        [EVNotificationCenter postNotificationName:CCIMUserHasChanged object:@{kImuser : imuser}];
    }
}

- (void)setName:(NSString *)name
{
    _name = [name copy];
    [EVBaseToolManager setUserNameToLocal:name];
}

- (void)setLogourl:(NSString *)logourl
{
    if ( ![logourl isKindOfClass:[NSString class]] )
    {
        return;
    }
    
    _logourl = logourl;
}



+ (BOOL)checkCurrUserByName:(NSString *)name
{
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    return [loginInfo.name isEqualToString:name];
}

- (void)setBirthday:(NSString *)birthday {
    if ( birthday == nil && [birthday isKindOfClass:[NSNull class]] )
    {
        return;
    }
    _birthday = [birthday copy];
}

- (void)setGender:(NSString *)gender
{
    _gender = [gender copy];
    if ( [gender isEqualToString:@"male"] )
    {
        self.sexStr = kE_GlobalZH(@"e_male");
    }
    else
    {
        self.sexStr = kE_GlobalZH(@"e_female");
    }
}

- (void)setSessionid:(NSString *)sessionid
{
    if ( sessionid == nil )
    {
        sessionid = [CCUserDefault objectForKey:SESSION_ID_STR];
    }
    _sessionid = [sessionid copy];
    [EVBaseToolManager saveSessionId:_sessionid];
}

- (void)setToken:(NSString *)token
{
    if ( [self.authtype isEqualToString:kAuthTypePhone] )
    {

    }
    _token = [token copy];
}

+ (NSDictionary *)gp_objectClassesInArryProperties
{
    return @{@"auth" : [EVRelationWith3rdAccoutModel class]};
}

- (NSMutableDictionary *)userInfoParams
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( self.gender.length  )
    {
        params[kGender] = self.gender;
    }
    
    if ( self.signature.length )
    {
        params[kSignature] = self.signature;
    }
    else
    {
        params[kSignature] = @"";
    }
    
    if ( self.nickname.length )
    {
        params[kDisplayname] = self.nickname;
    }
    
    if ( self.birthday.length )
    {
        params[kBirthday] = self.birthday;
    }
    
    if ( self.location.length )
    {
        params[kLocation] = self.location;
    }
    
    if ( self.introduce.length )
    {
        params[kIntroduce] = self.introduce;
    }

    
    if (self.unionid.length)
    {
        params[kUnionid] = self.unionid;
    }
    
    if (self.credentials.length) {
        params[kCredentials] = self.credentials;
    }
    
    return params;
}

- (NSMutableDictionary *)userRegistParams
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( ![self.loginTag isEqualToString:kCCPhoneLoginTag] )
    {
#ifdef EVDEBUG
        assert(self.authtype.length);
        assert(self.nickname.length);
        assert(self.token.length);
#endif
    }
    params[kAuthType] = self.authtype;
    params[kToken] = self.token;
    if ( ![NSString isBlankString:self.nickname] )
    {
        params[kNickName] = self.nickname;
    }
    
    if ( ![NSString isBlankString:self.location] )
    {
        params[kLocation] = self.location;
    }
    
    if ( ![NSString isBlankString:self.birthday] )
    {
        params[kBirthday] = self.birthday;
    }
    
    if ( ![NSString isBlankString:self.signature] )
    {
        params[kSignature] = self.signature;
    } else {
        params[kSignature] = @"";
    }
    
    if ( ![NSString isBlankString:self.gender]  )
    {
        params[kGender] = self.gender;
    }
    
    if ( ![NSString isBlankString:self.password] )
    {
        params[kPassword] = self.password;
    }
    
    if ( ![NSString isBlankString:self.logourl] )
    {
        params[kLogourl] = self.logourl;
    }
    
    if ( ![self.authtype isEqualToString:kAuthTypePhone] )
    {
        params[kAccess_token] = self.access_token;
        if ( self.refresh_token )
        {
            params[kRefresh_token] = self.refresh_token;
        }
        params[kExpires_in] = self.expires_in;
    }
    
    if ( ![NSString isBlankString:self.unionid] )
    {
        params[kUnionid] = self.unionid;
    }
    
    return params;
}

- (void)setNickname:(NSString *)nickname
{
    _nickname = [nickname copy];
    [EVBaseToolManager saveUserDisPlaynameToLocal:_nickname];
}

- (void)setPassword:(NSString *)password
{
    NSString *pwd_md5 = [password md5String];
    if (![_password isEqualToString:pwd_md5])
    {
        _password = [pwd_md5 copy];
    }
}

- (id)initWithCoder:(NSCoder *)decoder
{
    EVLoginInfo *loginInfo = [[[self class] alloc] init];
    loginInfo.auth = [decoder decodeObjectForKey:@"auth"];
    loginInfo.sexStr = [decoder decodeObjectForKey:@"sexStr"];
    loginInfo.hasLogin = [decoder decodeBoolForKey:@"hasLogin"];
    loginInfo.name = [decoder decodeObjectForKey:@"name"];
    loginInfo.sessionid = [decoder decodeObjectForKey:@"sessionid"];
    loginInfo.gender = [decoder decodeObjectForKey:@"gender"];
    loginInfo.authtype = [decoder decodeObjectForKey:@"authtype"];
    loginInfo.birthday = [decoder decodeObjectForKey:@"birthday"];
    loginInfo.nickname = [decoder decodeObjectForKey:@"nickname"];
 
    loginInfo.vip = [decoder decodeIntegerForKey:@"vip"];
    loginInfo.location = [decoder decodeObjectForKey:@"location"];
    loginInfo.signature = [decoder decodeObjectForKey:@"signature"];
    loginInfo.logourl = [decoder decodeObjectForKey:@"logourl"];
    loginInfo.access_token = [decoder decodeObjectForKey:@"access_token"];
    loginInfo.refresh_token = [decoder decodeObjectForKey:@"refresh_token"];
    loginInfo.expires_in = [decoder decodeObjectForKey:@"expires_in"];
    loginInfo.token = [decoder decodeObjectForKey:@"token"];
    loginInfo.password = [decoder decodeObjectForKey:@"password"];
    loginInfo.phone = [decoder decodeObjectForKey:@"phone"];
    loginInfo.imuser = [decoder decodeObjectForKey:@"imuser"];
    loginInfo.impwd = [decoder decodeObjectForKey:@"impwd"];
//    loginInfo.imLoginInfo = [decoder decodeObjectForKey:@"imLoginInfo"];
    loginInfo.unionid = [decoder decodeObjectForKey:kUnionid];
    loginInfo.barley = [decoder decodeIntegerForKey:@"barley"];
    loginInfo.ecoin = [decoder decodeIntegerForKey:@"ecoin"];

    
    loginInfo.registeredSuccess = [decoder decodeBoolForKey:@"registeredSuccess"];
    return loginInfo;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.password forKey:@"password"];
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.expires_in forKey:@"expires_in"];
    [encoder encodeObject:self.refresh_token forKey:@"refresh_token"];
    [encoder encodeObject:self.access_token forKey:@"access_token"];
    [encoder encodeObject:self.logourl forKey:@"logourl"];
    
    [encoder encodeObject:self.signature forKey:@"signature"];
    [encoder encodeObject:self.location forKey:@"location"];
    [encoder encodeObject:self.nickname forKey:@"nickname"];
    
    [encoder encodeObject:self.birthday forKey:@"birthday"];
    [encoder encodeObject:self.auth forKey:@"auth"];
    
    [encoder encodeObject:self.authtype forKey:@"authtype"];
    [encoder encodeObject:self.gender forKey:@"gender"];
    [encoder encodeObject:self.sessionid forKey:@"sessionid"];
    [encoder encodeObject:self.name forKey:@"name"];
    
    [encoder encodeObject:self.sexStr forKey:@"sexStr"];
    [encoder encodeBool:self.hasLogin forKey:@"hasLogin"];
    [encoder encodeInteger:self.vip forKey:@"vip"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    
    [encoder encodeObject:self.imuser forKey:@"imuser"];
    [encoder encodeObject:self.impwd forKey:@"impwd"];
    
//    [encoder encodeObject:self.imLoginInfo forKey:@"imLoginInfo"];
    [encoder encodeObject:self.unionid forKey:kUnionid];
    [encoder encodeBool:self.registeredSuccess forKey:@"registeredSuccess"];
    
    [encoder encodeInteger:self.barley forKey:@"barley"];
    [encoder encodeInteger:self.ecoin forKey:@"ecoin"];
    
}

- (void)synchronized
{
    EVLog(@"%@",kLoginInfoPath);
    if ([self.name isEqualToString:@""] || self.name == nil) {
        return;
    }
    if ( [NSKeyedArchiver archiveRootObject:self toFile:kLoginInfoPath] )
    {
        EVLog(@"archieve success");
    }
    else
    {
        EVLog(@"archieve fail");
    }
}

+ (EVLoginInfo *)localObject
{
    EVLoginInfo *info = [NSKeyedUnarchiver unarchiveObjectWithFile:kLoginInfoPath];
    return info;
}

+ (void)cleanLoginInfo
{
    [[NSFileManager defaultManager] removeItemAtPath:kLoginInfoPath error:NULL];
    [EVStockBaseModel clearStock];
}

+ (BOOL)hasLogged {
    
    NSString *session = [CCUserDefault objectForKey:SESSION_ID_STR];
    if (session && session.length > 0) {
        return YES;
    }
    return NO;
}

@end
