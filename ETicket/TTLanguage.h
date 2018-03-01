//
//  TTLanguage.h
//  ETicket
//
//  Created by chunjian wang on 2017/12/12.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 supporting for switching string localizations at runtime
 */
#define kPersistPreferredLanguage @"PreferredLanguageKey"

NSString *TTLocalizedString(NSString *key);

#ifdef NSLocalizedString
#undef NSLocalizedString
#endif
#define NSLocalizedString(key, comment) TTLocalizedString(key)

#define L(key) TTLocalizedString(key)

void TTSetPreferredLanguage(NSString *language);
