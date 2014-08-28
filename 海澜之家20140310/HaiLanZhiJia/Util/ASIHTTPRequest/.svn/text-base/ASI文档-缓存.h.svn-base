//
//  ASI文档.h
//  ASILoaderDemo
//
//  Created by qianzhenlei on 12-3-16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//
// 官方文档地址：http://allseeing-i.com/ASIHTTPRequest/How-to-use

/*

 
 使用下载缓存
 
 ASIDownloadCache 以及 ASICacheDelegate 的API在v1.8中已经改变，如果从v1.7升级的话，你需要更新你的代码。
 特别是，缓存策略的可用选项是不同的，并且你现在可以将多个缓存策略合并到单个请求中。
 
 ASIHTTPRequest可以自动保存下载数据到一个缓存，以便以后使用。许多情况下这会很有帮助：
 你想要访问数据，在没有因特网连接不能重新下载时；
 你想下载些东西，仅在你上次下载后它有了变化时；
 你用的内容永不改变，所以你只想下载它一次；
 
 在之前的ASIHTTPRequest版本中，处理以上情况意味着你自己手动保存这些数据。使用一个下载缓存可以在一些情况下减少你自己编写本地存储机制的需求。
 
 ASIDownloadCache是一个简单的url缓存，可以被用于缓存get请求的响应。为了符合响应缓存的条件，请求必须成功(没有错误)，服务器必须返回一个200 ok的http响应码，或者从v1.8.1开始，支持301,302,303,307重定向的状态码。
 
 开启响应缓存很简单：
 [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
 
 开启之后，所有的请求会自动使用缓存。如果你喜欢，你可以为独立的请求设置共享缓存：
 ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
 [request setDownloadCache:[ASIDownloadCache sharedCache]];
 
 缓存不限于单个，你可以创建任意多个缓存。当你自己创建缓存时，必须设置缓存的存储路径 －这应该是一个可写的文件夹：
 
 ASIDownloadCache *cache = [[[ASIDownloadCache alloc] init] autorelease];
 [cache setStoragePath:@"/Users/ben/Documents/Cached-Downloads"];
 
 // Don't forget - you are responsible for retaining your cache!
 [self setMyCache:cache];
 
 ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
 [request setDownloadCache:[self myCache]];
 
 
 
 关于缓存策略
 缓存策略是在信息存储于缓存中时你主要的控制方法，以及何时优先使用缓存的数据，而不是重新下载数据。
 
 独立请求的缓存策略可以使用它的cachePolicy属性。缓存策略使用位掩码(bitmask)定义，所以你可以组合多个选项来创建想要的策略：
 // Always ask the server if there is new content available, 
 // If the request fails, use data from the cache even if it should have expired.
 [request setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
 
 你可以使用下列选项来定义一个请求的缓存策略：
 
 ASIUseDefaultCachePolicy
 默认缓存策略，当你对请求应用此策略时，它会使用缓存的defaultCachePolicy，ASIDownloadCache的默认缓存策略是ASIAskServerIfModifiedWhenStaleCachePolicy，你不应该将此策略和其他策略组合使用。
 
 ASIDoNotReadFromCacheCachePolicy
 请求不会从缓存读取数据
 
 ASIDoNotWriteToCacheCachePolicy
 请求不会保存到缓存
 
 ASIAskServerIfModifiedWhenStaleCachePolicy
 这是ASIDownloadCaches的默认缓存策略。使用了它，请求会首先查看缓存中是否有可用的缓存响应数据。如果没有，请求会照常进行。
 如果有没有过期的缓存数据，请求会使用它而不去访问服务器。如果缓存数据过期了，请求将执行一个有条件的get去获取是否有可用的升级版本。如果服务器表示缓存的数据就是最新的，那么缓存的数据将被使用，新的数据不会被下载。这时，缓存的过期时间(expiry date)将根据服务器新的过期时间而被更新。如果服务器提供了更新内容，则将被下载，新的数据和过期时间将被写入缓存。
 
 ASIAskServerIfModifiedCachePolicy
 这个策略和ASIAskServerIfModifiedWhenStaleCachePolicy相同，只是请求每次都会询问服务器是否有新的数据
 
 ASIOnlyLoadIfNotCachedCachePolicy
 只要存在缓存数据，总是会被使用，即使它已经过期。
 
 ASIDontLoadCachePolicy
 请求仅在响应已经被缓存时成功。如果请求没有任何响应被缓存，请求会终止，并且也不会为此请求设置错误。
 
 ASIFallbackToCacheIfLoadFailsCachePolicy
 如果请求失败，将会退回到缓存数据。如果失败后使用了缓存的数据，请求将会成功而不报错。你一般会将它和其他策略混合使用，因为此策略仅在发生问题时用于指定行为。
 
 
 当你为缓存设置了defaultCachePolicy属性，所有的请求将会使用这个缓存策略，除非他们自己设置了自定义的策略。
 
 
 
 
 关于存储策略
 存储策略允许你定义特定响应的缓存将被保存多久，ASIHTTPRequest目前支持两种存储策略：
 ASICacheForSessionDurationCacheStoragePolicy 是默认值。响应仅在会话期间被保存，并将在缓存首次使用后被删除，或者当调用[ASIHTTPRequest clearSession] 时被删除。
 使用ASICachePermanentlyCacheStoragePolicy，缓存数据将被永久保存，要用这个存储策略，可将它设置到一个请求上：
 ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
 [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
 
 要手动清除缓存，调用clearCachedResponsesForStoragePolicy，传入你希望清除的缓存数据的存储类型：
 [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
 
 
 
 其他缓存特性
 // 当你关掉shouldRespectCacheControlHeaders, 响应数据将被保存，即使服务器明确要求不要缓存他们
 // (eg with a cache-control or pragma: no-cache header)
 [[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:NO];
 
 为请求设置secondsToCache，覆盖了由服务器设置的任何过期时间，一直保存响应数据直到secondsToCache秒到期。
 ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
 [request setSecondsToCache:60*60*24*30]; // Cache for 30 days
 
 
 在请求运行后，didUseCachedResponse将在响应由缓存返回时，返回yes
 [request didUseCachedResponse];
 
 
 询问缓存请求数据的保存路径，这是使用下载缓存最高效的方式，因为数据不必在请求完成后被拷贝到缓存
 [request setDownloadDestinationPath:
 [[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:request]];
 
 
 写你自己的缓存
 
 如果你已经有一个下载缓存，并想将它接入到ASIHTTPRequest，或者你想要写自己的缓存，可以让你的缓存实现ASICacheDelegate协议。


*/